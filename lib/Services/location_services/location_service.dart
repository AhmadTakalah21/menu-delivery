import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  Stream<Position>? _positionStream;

  /// ✅ الحصول على الموقع الحالي
  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 🔍 التأكد من تفعيل خدمة الموقع
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('⚠️ خدمة الموقع غير مفعلة');
    }

    // 🔐 التأكد من أذونات الوصول للموقع
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('🚫 تم رفض إذن الوصول إلى الموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('❌ تم رفض الإذن بشكل دائم');
    }

    // 📍 إرجاع الموقع الحالي
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /// ✅ إرسال الموقع إلى الـ Backend
  Future<void> sendLocationToBackend(String userId, double latitude, double longitude, String token) async {
    print('📍 Latitude: $latitude, Longitude: $longitude');

    final url = Uri.parse('https://tech.medical-clinic.serv00.net/delivery_api/location_tracking');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': userId,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ تم إرسال الموقع بنجاح');
      } else {
        print('❌ فشل إرسال الموقع: ${response.statusCode}');
        print('📩 الرسالة: ${response.body}');
      }
    } catch (e) {
      print('⚠️ حدث خطأ أثناء إرسال الموقع: $e');
    }
  }

  /// ✅ تتبع الموقع بشكل مستمر وإرساله إلى السيرفر
  void startLocationTracking(String userId, String token) {
    // ✅ التأكد من عدم تكرار التتبع
    if (_positionStream != null) {
      print('🚨 التتبع مفعل مسبقًا');
      return;
    }

    // ✅ إعدادات التتبع
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,  // 🎯 دقة عالية
        distanceFilter: 2,               // 🔄 تحديث كل 10 أمتار
      ),
    );

    // ✅ الاستماع لتحديثات الموقع
    _positionStream!.listen((Position position) {
      print('📡 موقع جديد: ${position.latitude}, ${position.longitude}');
      sendLocationToBackend(userId, position.latitude, position.longitude, token);
    });
  }

  /// ✅ إيقاف تتبع الموقع
  void stopLocationTracking() {
    if (_positionStream != null) {
      _positionStream = null;
      print('🛑 تم إيقاف تتبع الموقع');
    }
  }
}
