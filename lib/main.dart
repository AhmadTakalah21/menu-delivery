import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALSettings/ALSettings.dart';
import 'package:shopping_land_delivery/Services/Translations/LocalConfigration/LocalString.dart';



ALSettings  alSettings =Get.put(ALSettings());

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // await Firebase.initializeApp(options: Platform.isAndroid?DefaultFirebaseOptions.android:DefaultFirebaseOptions.android,);
  // ALMethode.initializeAppFirebaseMessaging();
  // CLNotification().configuration();
  // CLNotification().cancelAll();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return   DefaultTextStyle(
      style: const TextStyle(
          overflow: TextOverflow.ellipsis
      ),
      child: SafeArea(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Delivery",
          initialRoute: Routes.SPLASH,
          theme:  ThemeData(useMaterial3: false,),
          translations: LocalString(),
          getPages: AppPages.routes,
          routingCallback: (routing) {
            alSettings.routeName.value=routing!.current;
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}


//import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class MyFirebaseMessagingService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   // معالج الرسائل في الخلفية
//   static Future<void> backgroundMessageHandler(RemoteMessage message) async {
//     print("Received background message: ${message.notification?.title}");
//     // يمكنك إضافة منطق لحفظ البيانات أو عرض إشعار محلي
//   }
//
//   void initialize() {
//     // تهيئة Firebase Messaging للاستماع للرسائل في الخلفية
//     FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
//
//     // الحصول على FCM Token
//     FirebaseMessaging.instance.getToken().then((token) {
//       print("FCM Token: $token");
//     });
//
//     // التعامل مع الرسائل في المقدمة
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         print('Foreground notification: ${message.notification?.title}');
//
//         // عرض إشعار محلي (إذا كنت ترغب في ذلك)
//         _showLocalNotification(message);
//       }
//     });
//
//     // التعامل مع النقر على الإشعار (عند فتح التطبيق من إشعار)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message clicked! ${message.notification?.title}');
//       // هنا يمكنك تحديد الشاشة التي يجب الانتقال إليها
//     });
//   }
//
//   // عرض إشعار محلي
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'default_channel', // معرف القناة
//       'إشعارات التطبيق', // اسم القناة
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//     const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
//
//     // عرض الإشعار المحلي
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       platformDetails,
//       payload: 'item x', // بيانات مرفقة للإشعار (اختياري)
//     );
//   }
// }