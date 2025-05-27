
// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALNotification.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALConstants/DefaultFirebaseOptions.dart';
import 'package:shopping_land_delivery/Model/Model/CurrentUser.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Controllers/HomeController.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Notifications/Views/Notifications.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Search/Controllers/SearchControllers.dart';
import 'package:shopping_land_delivery/Pages/WelcomePage/WelcomePage.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:shopping_land_delivery/main.dart';
import 'package:uuid/uuid.dart';

import '../Services/location_services/location_service.dart';



enum SharedPreferencesType {
  int,
  string,
  bool,
  listString
}
enum ToastType {
  error,
  success,
  warning,
  info
}





class ALMethode {



  static  Future<Color> getDominantColor(String imageUrl) async {
    // Load the image
    final ImageProvider imageProvider = NetworkImage(imageUrl);
    final Completer<ui.Image> completer = Completer();
    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(info.image),
      ),
    );
    final ui.Image image = await completer.future;

    // Get the image pixels as byte data
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final Uint8List pixels = byteData!.buffer.asUint8List();

    // Analyze the pixels to find the dominant color
    final Map<int, int> colorCount = {};
    for (int i = 0; i < pixels.length; i += 4) {
      // Convert the RGBA pixels to a Color object ignoring the alpha channel
      final Color color = Color.fromARGB(255, pixels[i], pixels[i + 1], pixels[i + 2]);
      if (color != Colors.white && color != Colors.black) {
        // Count the occurrence of the color
        colorCount[color.value] = (colorCount[color.value] ?? 0) + 1;
      }
    }

    // Find the most dominant color, excluding pure white and black unless necessary
    final int? dominantColorValue = colorCount.keys.reduce((a, b) => colorCount[a]! > colorCount[b]! ? a : b);
    Color dominantColor = Color(dominantColorValue ?? Colors.white.value); // Fallback to white

    // If the only dominant color is white or black and there are other colors, exclude them
    if ((dominantColor == Colors.white || dominantColor == Colors.black) && colorCount.isNotEmpty) {
      final Map<int, int> filteredColorCount = Map.of(colorCount)..remove(Colors.white.value)..remove(Colors.black.value);
      if (filteredColorCount.isNotEmpty) {
        final int filteredDominantColorValue = filteredColorCount.keys.reduce((a, b) => filteredColorCount[a]! > filteredColorCount[b]! ? a : b);
        dominantColor = Color(filteredDominantColorValue);
      }
    }

    return dominantColor;
  }

  static findDependencies (){
    try{ CartControllers cart = Get.find(); cart.onInit();} catch(e){}
    try{ SearchControllers search = Get.find(); search.onInit();} catch(e){}
    try{ HomeController home = Get.find(); home.onInit();} catch(e){}
    // try{ OffersControllers offers = Get.find(); offers.onInit();} catch(e){}
  }

  static String formatNumberWithSeparators(String? nu) {
  try{
    if(nu==null) {
      return nu.toString();
    }
    double number =double.parse(nu.toString().replaceAll(alSettings.currency, '').trim());
    // Create a NumberFormat instance with the desired format.
    final format = NumberFormat('#,###');

    // Format the number using the NumberFormat instance.
    final formattedNumber = format.format(number);

    return '$formattedNumber ${alSettings.currency.tr}';
  }
  catch(e)
    {
      return nu.toString();
    }
  }


  static ui.TextDirection getDirection(String text) {
    final string = text.trim();
    if (string.isEmpty) return ui.TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return ui.TextDirection.rtl;
    }
    return ui.TextDirection.ltr;
  }

  static Future<void> addSharedPreferencesWithType({required String kay,required dynamic value, required SharedPreferencesType type}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    switch(type)
    {
      case SharedPreferencesType.int:
        {
          preferences.setInt(kay, int.parse(value.toString()));
          break;
        }
      case SharedPreferencesType.string:
        {
          preferences.setString(kay, value.toString());
          break;
        }
      case SharedPreferencesType.bool:
        {
          preferences.setBool(kay, value as bool);
          break;
        }
      case SharedPreferencesType.listString:
        {
          preferences.setStringList(kay, value as List<String>);
          break;
        }
    }
  }

  static Future<dynamic> getSharedPreferencesWithType({required String kay, required SharedPreferencesType type}) async {
    SharedPreferences preferences  = await SharedPreferences.getInstance();
    Object? object;

    switch(type)
    {
      case SharedPreferencesType.int:
        {
          object= preferences.getInt(kay);
          break;
        }
      case SharedPreferencesType.string:
        {
          object=  preferences.getString(kay);
          break;
        }
      case SharedPreferencesType.bool:
        {
          object = preferences.getBool(kay);
          break;
        }
      case SharedPreferencesType.listString:
        {
          object =  preferences.getStringList(kay);
          break;
        }
    }
    return object;
  }

  static showToast({required String title,required String message,required ToastType type ,required BuildContext context}) {
    Color color =Colors.redAccent;
    IconData icon = Icons.info;
    switch(type)
    {
      case ToastType.error:
        {
          icon=Icons.error;
          break;
        }
      case ToastType.success:
        {
          icon=CupertinoIcons.checkmark_seal_fill;
          color=Colors.green.shade300;
          break;
        }
      case ToastType.warning:
        {
          icon=Icons.warning_outlined;
          color=Colors.orangeAccent.shade200;
          break;
        }
      case ToastType.info:
        {
          icon=Icons.info;
          color=Colors.blue.shade300;
          break;
        }
    }
    Flushbar(
      title:title ,
      maxWidth: Get.width*0.905,
      message: message,
      icon: Icon(
        icon,
        size: 28.0,
        color: color,
      ),
      duration: const Duration(milliseconds: 3300),
      margin: const EdgeInsets.all(6),
      backgroundGradient: const LinearGradient(colors: [AppColors.basicColor,AppColors.basicColor]),
      borderRadius: BorderRadius.circular(8),
      boxShadows: [BoxShadow(color:color, offset: const Offset(0.0, .1), blurRadius: 1.0,)],
    ).show(context);
  }

  static Future<void> setUserInfo({required CurrentUser data,}) async{

    try
    {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String> dataUser=[];

      dataUser.add(data.userId.toString());
      dataUser.add(data.email.toString());
      dataUser.add(data.password.toString());
      dataUser.add(data.fullName.toString());
      dataUser.add(data.apiKey.toString());
      dataUser.add(data.fcmToken.toString());
      dataUser.add(data.image.toString());
      dataUser.add(data.locale.toString());
      dataUser.add(data.userName.toString());
      dataUser.add(data.citiesId.toString());

      await preferences.setStringList("session", dataUser);
    }
    catch(E)
    {

    }
  }

  static Map<String, String> getApiHeader() {

    if(alSettings.currentUser!=null && alSettings.currentUser!.apiKey!=null )
      {
        return {
          'Authorization': 'Bearer ${alSettings.currentUser!.apiKey}',
          'language':alSettings.currentUser!.locale.toString(),
          'Accept': 'Application/json'
        };
      }
    else
      {
        return {};
      }

  }

  static String getApiHeaderWithOutAuthorization() {
    return 'token ${alSettings.currentUser!.apiKey}';
  }

  static Future<void> logout({bool? message, String? messageT}) async {
    try {
      // 1. إيقاف تتبع الموقع
      final locationController = Get.isRegistered<LocationController>()
          ? Get.find<LocationController>()
          : null;
      locationController?.stopListeningToLocationChanges();

      // 2. إغلاق WebSocket
      LocationService().closeAllConnections();

      // 3. حذف بيانات المستخدم
      await deleteUserInfo();

      // 4. حذف FCM Token (اختياري)
      // await FirebaseMessaging.instance.deleteToken();

      // 5. إعادة تهيئة الألوان
      FlutterStatusbarcolor.setNavigationBarColor(const Color(0xFFF7F7F7));
      FlutterStatusbarcolor.setStatusBarColor(const Color(0xFFF7F7F7));

      // 6. التوجيه
      await Get.offAll(WelcomePage());

      // 7. حذف جميع Controllers
      Get.deleteAll(force: true);

      // 8. إظهار رسالة (اختياري)
      if (message != null) {
        ALConstantsWidget.showDialogIosOrAndroid(
          content: messageT.toString(),
          onPressOKButton: () async {},
          towButton: false,
        );
      }

      // 9. إعادة تهيئة الإعدادات
      alSettings.onInit();

    } catch (e) {
      print("⚠️ خطأ أثناء تسجيل الخروج: $e");
    }
  }



  static Future<void> deleteUserInfo() async {
    SharedPreferences preferences  = await SharedPreferences.getInstance();
    await preferences.remove("session");
    alSettings.currentUser=null;
  }



  static void onClickNotification(String payloads)  async {
    if(alSettings.routeName.value!=Routes.Notifications)
      {
        Get.to(Notifications());
      }

  }

  static void listenNotification() => CLNotification.onNotification.stream.listen(onClickNotification);

  static initializeAppFirebaseMessaging ()async{
    await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((remoteMessage) async {
      int id = Random().nextInt(99999);
      CLNotification().showNote(id: id,title: remoteMessage.notification!.title.toString(),body:  remoteMessage.notification!.body.toString(),payload:remoteMessage.data.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) async {

      Get.to(Notifications());



    });
  }

  static Future<bool> security() async{
    try{
      https.Response response;
      response = await https.get(Uri.parse('https://levantsecurity.000webhostapp.com/shopping_security.php'),);
      var date =json.decode(response.body) ;
      return date['security'];
    }
    catch(e){return false;}
  }


}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp(options: Platform.isAndroid?DefaultFirebaseOptions.android:DefaultFirebaseOptions.android,);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

}
