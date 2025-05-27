



// import 'dart:io';
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'location_service.dart';
//
// class LocationController extends GetxController {
//   var isLoading = false.obs;
//   var userPosition = Rx<Position?>(null);
//   final LocationService _locationService = LocationService();
//
//   Future<void> openLocationSettings() async {
//     if (Platform.isAndroid) {
//       final AndroidIntent intent = AndroidIntent(
//         action: 'android.settings.LOCATION_SOURCE_SETTINGS',
//       );
//       await intent.launch();
//     } else if (Platform.isIOS) {
//       // توجيه iOS للإعدادات
//       await openAppSettings();
//     }
//   }
//
//   /// ✅ الحصول على الموقع الحالي وإرساله لمرة واحدة
//   Future<void> fetchUserLocation(String userId, String token) async {
//     try {
//       isLoading.value = true;
//
//       // ✅ التأكد من أن المستخدم منح إذن الموقع
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           Get.snackbar("🚫 خطأ", "تم رفض إذن الموقع");
//           isLoading.value = false;
//           return;
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         Get.snackbar("❌ خطأ", "تم رفض الإذن بشكل دائم");
//         // التوجيه إلى إعدادات التطبيق لتمكين الإذن
//         openLocationSettings();
//         isLoading.value = false;
//         return;
//       }
//
//       // ✅ الحصول على الموقع الحالي
//       Position position = await _locationService.getUserLocation();
//       userPosition.value = position;
//
//       // ✅ إرسال الموقع إلى الـ Backend عبر WebSocket مباشرة
//       await _locationService.sendLocationToBackendViaWebSocket(
//         userId,
//         position.latitude,
//         position.longitude,
//         token,
//       );
//
//       Get.snackbar("✅ نجاح", "تم تحديد وإرسال الموقع بنجاح");
//     } catch (e) {
//       Get.snackbar("❌ خطأ", "فشل في تحديد الموقع: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// ✅ بدء تتبع الموقع في الخلفية باستخدام `ForegroundService`
//   Future<void> startLocationTracking(String userId, String token) async {
//     await LocationService.initializeForegroundService();
//     Get.snackbar("✅ بدء التتبع", "يتم الآن تتبع الموقع في الخلفية");
//
//     // إرسال الموقع بشكل مستمر عبر WebSocket في الخلفية
//     _locationService.startLocationUpdates(userId, token);
//   }
//
//   /// ✅ إيقاف تتبع الموقع في الخلفية
//   Future<void> stopLocationTracking() async {
//     final service = FlutterBackgroundService();
//     service.invoke('stopService'); // ✅ الطريقة الصحيحة لإيقاف الخدمة
//     Get.snackbar("🛑 تم الإيقاف", "تم إيقاف تتبع الموقع في الخلفية");
//
//     // إيقاف الاستماع لموقع المستخدم
//     _locationService.stopLocationUpdates();
//   }
// }
