



import 'dart:convert';

import 'package:shopping_land_delivery/Model/Model/ServerResponse.dart';

import '../../../../../Model/Repositories/ApiClient/ALApiClient.dart';
import '../../../../../main.dart';

class OrderDetailsRepositories
{

  ServerResponse message=ServerResponse();

  Future<bool> display_order_by_id({required Map<String, dynamic> bodyData}) async {
    try {
      // ✅ استدعاء API مع طباعة البيانات المرسلة للتصحيح
      print("🔎 Request Data: $bodyData");

      var response = await ALApiClient(
        bodyData: bodyData,
        methode: 'show_order_by_id',
      ).request(get: true);

      // ✅ طباعة الاستجابة للتحقق من محتواها
      print("✅ Response: $response");

      // ✅ التحقق من نوع الاستجابة بدلاً من runtimeType
      if (response != null && response is String) {
        var jsonResponse = json.decode(response);

        // ✅ تحقق من وجود المفتاح 'state' قبل الوصول إليه
        if (jsonResponse is List && jsonResponse.isNotEmpty) {
          message = dataServerResponseFromJson(response).first;

          if (message.state == 1) {
            return true; // ✅ الطلب ناجح
          } else {
            print("❌ فشل في الاستجابة: الحالة ${message.state}");
            return false;
          }
        } else {
          print("⚠️ الاستجابة غير متوقعة أو فارغة");
          return false;
        }
      } else {
        print("⚠️ استجابة غير صالحة");
        return false;
      }
    } catch (e) {
      // ✅ طباعة الخطأ برسالة أوضح
      print("❌ خطأ أثناء تحميل الطلب: $e");
      return false;
    }
  }




  /// ✅ دالة لتحديث حالة الطلب
  Future<bool> updateOrder({required Map<String, String> bodyData}) async {
    try {
      // ✅ طباعة البيانات المرسلة
      print("📤 البيانات المرسلة: $bodyData");

      // ✅ إرسال الطلب
      var response = await ALApiClient(
        methode: 'update_order',
        bodyData: {
          'id': bodyData['id']!,
          'status': bodyData['status']!,
        },
      ).request(get: false);

      print("📥 استجابة السيرفر: $response");

      // ✅ التعامل مع استجابة السيرفر بناءً على نوعها
      if (response is String) {
        var decodedResponse = json.decode(response);

        if (decodedResponse is Map && decodedResponse.containsKey('status')) {
          if (decodedResponse['status'] == true) {
            print("✅ تم تحديث الطلب بنجاح (استجابة Map)");
            return true;
          }
        } else if (decodedResponse is List && decodedResponse.isNotEmpty) {
          var message = decodedResponse.first;
          if (message['status'] == 1) {
            print("✅ تم تحديث الطلب بنجاح (استجابة List)");
            return true;
          }
        }
      }

      // ❌ في حال لم تتطابق أي استجابة متوقعة
      print("❌ استجابة غير متوقعة من السيرفر.");
      return false;
    } catch (e) {
      print("❌ خطأ أثناء تحديث الطلب: $e");
      return false;
    }
  }













}