// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/Configuration/config.dart';



class ALApiClient {
  static var client = https.Client();
  String? methode;
  dynamic bodyData;

  ALApiClient({@required this.methode,@required this.bodyData,});
  request({bool? get, bool? isPagination, bool? delete, bool? isMulti}) async {
    try {
      https.Response response;
      var connectionStatus = await InternetConnectionChecker().connectionStatus;

      if (await InternetConnectionChecker().hasConnection && connectionStatus == InternetConnectionStatus.connected) {
        if (isMulti != null) {
          // ✅ في حالة الملفات المتعددة
          var request = https.MultipartRequest('POST', Uri.parse("$APIURL$methode"));
          bodyData.fields.forEach((element) {
            request.fields[element.key] = element.value;
          });
          request.headers.addAll(ALMethode.getApiHeader());
          var streamedResponse = await request.send();
          response = await https.Response.fromStream(streamedResponse);

        } else if (get == true) {
          // ✅ إذا كان GET
          response = await https.get(
            Uri.parse("$APIURL$methode").replace(queryParameters: bodyData),
            headers: ALMethode.getApiHeader(),
          );

        } else if (delete == true) {
          // ✅ إذا كان DELETE
          response = await https.delete(
            Uri.parse("$APIURL$methode").replace(queryParameters: bodyData),
            headers: ALMethode.getApiHeader(),
          );

        } else {
          // ✅ إذا كان POST (وهو المطلوب)
          response = await https.post(
            Uri.parse("$APIURL$methode"),
            body: bodyData,
            headers: ALMethode.getApiHeader(),
          );
        }

        // ✅ طباعة الاستجابة
        print("📥 استجابة السيرفر: ${utf8.decode(response.bodyBytes)}");

        var dataApi = json.decode(utf8.decode(response.bodyBytes));

        if ((dataApi['success'] != null || dataApi['status'] != null) && dataApi['code'] == 401) {
          ALMethode.logout(message: true, messageT: dataApi['message'] ?? '');
          return false;
        }

        if (isPagination != null) {
          return json.encode([
            {
              'status': 1,
              'description': dataApi['message'] ?? '',
              'data': dataApi['data'] != null ? json.encode(dataApi['data']) : null
            }
          ]);
        } else {
          return json.encode([
            {
              'status': ((dataApi['success'] != null && dataApi['success']) || (dataApi['status'] != null && dataApi['status'])) || dataApi['code'] == 402 ? 1 : 0,
              'description': dataApi['message'],
              'data': dataApi['data'] != null ? json.encode(dataApi['data']) : json.encode({'percent': dataApi['percent']})
            }
          ]);
        }
      } else {
        return json.encode([
          {'status': 0, 'description': 'no connection internet', 'data': null}
        ]);
      }
    } catch (e) {
      print("❌ خطأ أثناء تنفيذ الطلب: $e");
      return false;
    }
  }



}