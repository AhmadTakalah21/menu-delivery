import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  WebSocketChannel? _mainChannel;
  WebSocketChannel? _orderChannel;

  bool _subscribedMain = false;
  bool _subscribedOrder = false;

  // فتح قناة الموقع العام
  void initMainWebSocket() {
    if (_mainChannel != null) return;

    _mainChannel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.102:8080/app/bqfkpognxb0xxeax5bjc'),
    );

    _mainChannel?.sink.add(jsonEncode({
      'event': 'pusher:subscribe',
      'data': {'channel': 'locationUpdated'},
    }));

    _mainChannel?.stream.listen(
          (message) {
        print("📩 main: $message");
        final decoded = jsonDecode(message);
        if (decoded['event'] == 'pusher_internal:subscription_succeeded') {
          _subscribedMain = true;
          print("✅ تم الاشتراك في قناة الموقع العامة.");
        }
      },
      onError: (error) {
        print("❌ خطأ mainChannel: $error");
        _subscribedMain = false;
        _reconnectMain();
      },
      onDone: () {
        _subscribedMain = false;
        _reconnectMain();
      },
    );
  }

  // قناة الطلب (ديناميكية)
  void openOrderChannel(String orderId) {
    if (_orderChannel != null) return;

    final orderChannelName = 'order.$orderId';
    _orderChannel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.40:8080/app/bqfkpognxb0xxeax5bjc'),
    );

    _orderChannel?.sink.add(jsonEncode({
      'event': 'pusher:subscribe',
      'data': {'channel': orderChannelName},
    }));

    _orderChannel?.stream.listen(
          (message) {
        print("📩 order.$orderId: $message");
        final decoded = jsonDecode(message);
        if (decoded['event'] == 'pusher_internal:subscription_succeeded') {
          _subscribedOrder = true;
          print("✅ تم الاشتراك في order.$orderId");
        }
      },
      onError: (error) {
        print("❌ خطأ orderChannel: $error");
        _subscribedOrder = false;
        _reconnectOrder(orderId);
      },
      onDone: () {
        _subscribedOrder = false;
        _reconnectOrder(orderId);
      },
    );
  }

  void _reconnectMain() {
    _mainChannel = null;
    Future.delayed(Duration(seconds: 3), initMainWebSocket);
  }

  void _reconnectOrder(String orderId) {
    _orderChannel = null;
    Future.delayed(Duration(seconds: 3), () => openOrderChannel(orderId));
  }

  // إرسال للموقع إلى كلا القناتين
  Future<void> sendLocationToBackendViaWebSocket(
      double latitude,
      double longitude,
      String token,
      String userId,
      String? orderId,
      ) async {
    final payload = {
      'latitude': latitude.toStringAsFixed(6),
      'longitude': longitude.toStringAsFixed(6),
      'userId': userId,
    };

    // إرسال إلى القناة العامة
    if (_subscribedMain && _mainChannel != null) {
      try {
        _mainChannel?.sink.add(jsonEncode({
          'event': 'client-locationUpdated',
          'data': payload,
          'channel': 'locationUpdated',
        }));
      } catch (e) {
        print("⚠️ فشل إرسال الموقع للقناة العامة: $e");
      }
    }

    // إرسال إلى قناة الطلب
    if (orderId != null && _subscribedOrder && _orderChannel != null) {
      try {
        _orderChannel?.sink.add(jsonEncode({
          'event': 'client-locationUpdated',
          'data': payload,
          'channel': 'order.$orderId',
        }));
      } catch (e) {
        print("⚠️ فشل إرسال الموقع لقناة الطلب: $e");
      }
    }
  }

  // إغلاق الاتصالات
  void closeAllConnections() {
    try {
      _mainChannel?.sink.close();
      _orderChannel?.sink.close();
      _mainChannel = null;
      _orderChannel = null;
      _subscribedMain = false;
      _subscribedOrder = false;
      print("🔌 تم إغلاق جميع WebSocket.");
    } catch (e) {
      print("⚠️ خطأ أثناء الإغلاق: $e");
    }
  }

  void closeOrderChannel() {
    try {
      _orderChannel?.sink.close();
      _orderChannel = null;
      _subscribedOrder = false;
      print("🛑 تم إغلاق قناة الطلب.");
    } catch (e) {
      print("⚠️ خطأ أثناء إغلاق قناة الطلب: $e");
    }
  }
}


class LocationController extends GetxController {
  var isLoading = false.obs;
  var userPosition = Rx<Position?>(null);
  StreamSubscription<Position>? _positionStream;
  final LocationService _locationService = LocationService();

  // إرسال الموقع الحالي لمرة واحدة
  Future<void> fetchUserLocationAndSend(String token, String userId,{String? orderId}) async {
    try {
      isLoading.value = true;

      // تحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("🚫 خطأ", "تم رفض إذن الموقع");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("❌ خطأ", "تم رفض الإذن بشكل دائم");
        return;
      }

      // الحصول على الموقع
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      userPosition.value = position;

      // إرسال الموقع
      await _locationService.sendLocationToBackendViaWebSocket(
        position.latitude,
        position.longitude,
        token,
        userId,
        orderId,

      );

      Get.snackbar(" نجاح", "تم إرسال الموقع الحالي.");
    } catch (e) {
      Get.snackbar(" خطأ", "فشل في تحديد الموقع: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // بدء تتبع تغيّر الموقع وإرساله تلقائيًا
  void startListeningToLocationChanges(String token, String userId, {String? orderId}) {
    stopListeningToLocationChanges();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      userPosition.value = position;

      _locationService.sendLocationToBackendViaWebSocket(
        position.latitude,
        position.longitude,
        token,
        userId,
        orderId,
      );
    });

    print("📍 بدأ تتبع الموقع وإرساله${orderId != null ? " إلى قناة order.$orderId" : ""}.");
  }


  // إيقاف التتبع
  void stopListeningToLocationChanges() {
    _positionStream?.cancel();
    _positionStream = null;
    print("🛑 تم إيقاف تتبع الموقع.");
  }


  @override
  void onClose() {
    stopListeningToLocationChanges();
    super.onClose();
  }
}







//befor
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:android_intent_plus/flag.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import '../../main.dart';
//
// const String trackLocationTask = "trackLocation";
//
// class LocationService {
//   static final LocationService _instance = LocationService._internal();
//   factory LocationService() => _instance;
//   LocationService._internal() {
//     initWebSocket();
//   }
//
//   WebSocketChannel? _channel;
//   StreamSubscription<Position>? _positionStream;
//   bool _subscribed = false;
//
//   // ✅ دالة فتح إعدادات البطارية لتجاوز تحسين البطارية
//   Future<void> openBatteryOptimizationSettings() async {
//     try {
//       final intent = AndroidIntent(
//         action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
//         package: 'com.android.settings',
//         flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//       );
//       await intent.launch();
//     } catch (e) {
//       print("❌ فشل في فتح إعدادات تحسين البطارية: $e");
//     }
//   }
//
//   static Future<void> initializeForegroundService() async {
//     final service = FlutterBackgroundService();
//
//     if (await DeviceInfoPlugin().androidInfo.then((info) => info.version.sdkInt >= 33)) {
//       PermissionStatus status = await Permission.location.request();
//       if (!status.isGranted) {
//         print("🚫 إذن الموقع مرفوض، لن يعمل التتبع.");
//         return;
//       }
//     }
//
//     // فتح إعدادات البطارية لتجاوز تحسين البطارية
//     await LocationService().openBatteryOptimizationSettings();
//
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//         notificationChannelId: 'tracking_service',
//         initialNotificationTitle: '📡 التتبع نشط',
//         initialNotificationContent: 'يتم تتبع موقعك في الخلفية.',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration(
//         onForeground: onStart,
//         autoStart: true,
//       ),
//     );
//
//     service.startService();
//   }
//
//   static void onStart(ServiceInstance service) async {
//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: '📡 التتبع نشط',
//         content: 'يتم تتبع موقعك في الخلفية.',
//       );
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String token = prefs.getString('token') ?? "TOKEN";
//     if (token == "TOKEN") {
//       print('❌ فشل: التوكن غير موجود.');
//       return;
//     }
//
//     final locationService = LocationService();
//
//     Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.bestForNavigation,
//         distanceFilter: 10,
//       ),
//     ).listen((Position position) {
//       String userId = alSettings.currentUser?.userId ?? "defaultUserId";
//       print('📡 موقع جديد: ${position.latitude}, ${position.longitude}');
//       locationService.sendLocationToBackendViaWebSocket(userId, position.latitude, position.longitude, token);
//     });
//   }
//
//   Future<Position> getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print("❌ خدمة الموقع غير مفعلة.");
//       return Future.error('⚠️ خدمة الموقع غير مفعلة');
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('🚫 تم رفض الإذن');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('❌ تم رفض الإذن بشكل دائم');
//     }
//
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
//   }
//
//   Future<void> sendLocationToBackendViaWebSocket(
//       String userId, double latitude, double longitude, String token) async {
//     if (token.isEmpty) {
//       print("❌ التوكن غير صالح.");
//       return;
//     }
//
//     if (!_subscribed) {
//       print("🚫 لم يتم الاشتراك في القناة بعد. سيتم تجاهل الإرسال.");
//       return;
//     }
//
//     try {
//       if (_channel != null) {
//         final locationUpdated = jsonEncode({
//           'event': 'client-locationUpdated',
//           'data': {
//             'latitude': latitude.toStringAsFixed(6),
//             'longitude': longitude.toStringAsFixed(6),
//           },
//           'channel': 'locationUpdated',
//         });
//
//         print("📡 إرسال الموقع: $locationUpdated");
//         _channel?.sink.add(locationUpdated);
//         print("✅ تم الإرسال.");
//       } else {
//         print("❌ WebSocket غير متصل.");
//       }
//     } catch (e) {
//       print("⚠️ خطأ أثناء إرسال الموقع: $e");
//     }
//   }
//
//   void stopLocationUpdates() async {
//     final service = FlutterBackgroundService();
//     service.invoke('stopService');
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     print("🛑 تم حذف التوكن.");
//
//     _positionStream?.cancel();
//     _channel?.sink.close();
//     print("🛑 تم إيقاف التتبع والاتصال.");
//   }
//
//   void initWebSocket() {
//     if (_channel != null) return;
//
//     _channel = WebSocketChannel.connect(
//       Uri.parse('ws://192.168.1.40:8080/app/bqfkpognxb0xxeax5bjc'),
//     );
//
//     _channel?.sink.add(jsonEncode({
//       'event': 'pusher:subscribe',
//       'data': {
//         'channel': 'locationUpdated',
//       }
//     }));
//
//     _channel?.stream.listen(
//           (message) {
//         print("📩 الرسالة الواردة: $message");
//
//         try {
//           final decoded = jsonDecode(message);
//           if (decoded['event'] == 'pusher_internal:subscription_succeeded') {
//             _subscribed = true;
//             print("✅ تم الاشتراك بنجاح في القناة.");
//           }
//         } catch (e) {
//           print("⚠️ خطأ في تحليل الرسالة: $e");
//         }
//       },
//       onError: (error) {
//         print("❌ خطأ WebSocket: $error");
//         _reconnect();
//       },
//       onDone: () {
//         print("🔌 تم قطع الاتصال.");
//         _subscribed = false;
//         _reconnect();
//       },
//     );
//   }
//
//   void _reconnect() {
//     print("🔁 إعادة الاتصال بعد 3 ثوانٍ...");
//     _channel = null;
//     _subscribed = false;
//     Future.delayed(Duration(seconds: 3), () {
//       initWebSocket();
//     });
//   }
//
//   void startLocationUpdates(String userId, String token) {
//     _positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.bestForNavigation,
//         distanceFilter: 10,
//       ),
//     ).listen((Position position) {
//       print('📡 الموقع الحالي: ${position.latitude}, ${position.longitude}');
//       sendLocationToBackendViaWebSocket(userId, position.latitude, position.longitude, token);
//     });
//   }
// }
