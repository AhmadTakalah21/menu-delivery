import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'location_service.dart';

class LocationController extends GetxController {
  var isLoading = false.obs;
  var userPosition = Rx<Position?>(null);
  final LocationService _locationService = LocationService();

  /// ✅ الحصول على الموقع الحالي وإرساله لمرة واحدة
  Future<void> fetchUserLocation(String userId, String token) async {
    try {
      isLoading.value = true;

      // ✅ التأكد من أن المستخدم منح إذن الموقع
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

      // ✅ الحصول على الموقع الحالي
      Position position = await _locationService.getUserLocation();
      userPosition.value = position;

      // ✅ إرسال الموقع إلى الـ Backend
      await _locationService.sendLocationToBackend(
        userId,
        position.latitude,
        position.longitude,
        token,
      );

      Get.snackbar("✅ نجاح", "تم تحديد وإرسال الموقع بنجاح");
    } catch (e) {
      Get.snackbar("❌ خطأ", "فشل في تحديد الموقع: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ بدء تتبع الموقع في الخلفية وإرساله بشكل مستمر
  Future<void> startLocationTracking(String userId, String token) async {
    await _locationService.registerBackgroundTracking(userId, token);
    Get.snackbar("✅ بدء التتبع", "يتم الآن تتبع الموقع في الخلفية");
  }

  /// ✅ إيقاف تتبع الموقع في الخلفية
  Future<void> stopLocationTracking() async {
    await Workmanager().cancelAll();
    Get.snackbar("🛑 تم الإيقاف", "تم إيقاف تتبع الموقع في الخلفية");
  }
}