import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

class LocationController extends GetxController {
  var isLoading = false.obs;
  var userPosition = Rx<Position?>(null);
  final LocationService _locationService = LocationService();

  Stream<Position>? _positionStream;

  /// ✅ الحصول على الموقع الحالي وإرساله لمرة واحدة
  Future<void> fetchUserLocation(String userId, String token) async {
    try {
      isLoading.value = true;

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

  /// ✅ بدء تتبع الموقع بشكل مستمر وإرساله إلى السيرفر
  void startLocationTracking(String userId, String token) {
    if (_positionStream != null) {
      print('🚨 التتبع مفعل مسبقًا');
      return;
    }

    // ✅ إعداد التتبع المستمر
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,  // 🎯 دقة عالية
        distanceFilter: 10,               // 🔄 تحديث كل 10 أمتار
      ),
    );

    // ✅ الاستماع لتحديثات الموقع وإرسالها للسيرفر
    _positionStream!.listen((Position position) async {
      userPosition.value = position;

      await _locationService.sendLocationToBackend(
        userId,
        position.latitude,
        position.longitude,
        token,
      );

      print('📍 الموقع الحالي: ${position.latitude}, ${position.longitude}');
    });

    Get.snackbar("✅ بدء التتبع", "يتم الآن تتبع الموقع بشكل مستمر");
  }

  /// ✅ إيقاف تتبع الموقع
  void stopLocationTracking() {
    if (_positionStream != null) {
      _positionStream = null;
      print('🛑 تم إيقاف تتبع الموقع');
      Get.snackbar("🛑 تم الإيقاف", "تم إيقاف تتبع الموقع");
    }
  }
}
