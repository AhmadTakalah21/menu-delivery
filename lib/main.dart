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
          title: "Menu Delivery",
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
