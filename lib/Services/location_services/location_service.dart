import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String trackLocationTask = "trackLocation";

class LocationService {
  Stream<Position>? _positionStream;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LocationService() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// ✅ إعداد WorkManager لتتبع الموقع في الخلفية
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      if (task == trackLocationTask) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          print("🚫 خدمة الموقع غير مفعلة، WorkManager لن يعمل.");
          return Future.error('⚠️ خدمة الموقع غير مفعلة');
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return Future.error('❌ لم يتم منح إذن الموقع');
        }

        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
        final String userId = inputData?["userId"] ?? "";
        final String token = inputData?["token"] ?? "";

        if (userId.isNotEmpty && token.isNotEmpty) {
          LocationService().sendLocationToBackend(userId, position.latitude, position.longitude, token);
        }
      }
      return Future.value(true);
    });
  }

  /// ✅ تسجيل WorkManager لبدء تتبع الموقع في الخلفية
  Future<void> registerBackgroundTracking(String userId, String token) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("🚫 خدمة الموقع غير مفعلة، لن يتم تشغيل التتبع.");
      return;
    }

    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false); // ✅ تأكيد تعطيل وضع التصحيح
    await Workmanager().registerPeriodicTask(
      "1",
      trackLocationTask,
      frequency: const Duration(minutes: 15),
      inputData: {"userId": userId, "token": token},
    );

    await _showNotification("📡 التتبع نشط", "يتم تتبع موقعك في الخلفية"); // ✅ التأكد من عرض الإشعار
    print('🚀 تم تمكين التتبع في الخلفية');
  }


  /// ✅ الحصول على الموقع الحالي
  Future<Position> getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ خدمة الموقع غير مفعلة، التتبع متوقف.");
      return Future.error('⚠️ خدمة الموقع غير مفعلة');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("🚫 تم رفض إذن الموقع");
        return Future.error('🚫 تم رفض إذن الوصول إلى الموقع');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print("❌ تم رفض إذن الموقع بشكل دائم");
      return Future.error('❌ تم رفض الإذن بشكل دائم');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  /// ✅ تتبع الموقع بشكل مباشر عند فتح التطبيق
  Future<void> startLocationTracking(String userId, String token) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("🚫 خدمة الموقع غير مفعلة، لن يتم تشغيل التتبع.");
      return;
    }

    if (_positionStream != null) {
      print('🚨 التتبع مفعل مسبقًا');
      return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
        // إزالة timeInterval
      ),
    );

    _positionStream!.listen((Position position) {
      print('📡 موقع جديد: ${position.latitude}, ${position.longitude}');
      sendLocationToBackend(userId, position.latitude, position.longitude, token);
    });

  }

  /// ✅ إرسال الموقع إلى الـ Backend
  Future<void> sendLocationToBackend(String userId, double latitude, double longitude, String token) async {
    final url = Uri.parse('https://menuback.le.sy/delivery_api/location_tracking');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'id': userId, 'latitude': latitude.toStringAsFixed(6), 'longitude': longitude.toStringAsFixed(6)}),
      );
      if (response.statusCode == 200) {
        print('✅ تم إرسال الموقع بنجاح');
      } else {
        print('❌ فشل إرسال الموقع: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ حدث خطأ أثناء إرسال الموقع: $e');
    }
  }

  /// ✅ إيقاف تتبع الموقع فقط عند تسجيل الخروج
  void stopLocationTracking() {
    if (_positionStream != null) {
      _positionStream = null;
      print('🛑 تم إيقاف تتبع الموقع');
    }
    Workmanager().cancelAll();
    _showNotification("🛑 تم إيقاف التتبع", "تم إيقاف تتبع موقعك بعد تسجيل الخروج.");
  }

  /// ✅ إرسال إشعار للمستخدم عند بدء التتبع في الخلفية
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'location_tracking_channel',
      'تتبع الموقع',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}