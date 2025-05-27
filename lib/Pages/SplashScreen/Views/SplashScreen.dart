import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../ALConstants/AppColors.dart';
import '../../../Services/helper/status_bar.dart';
import '../../../main.dart';
import '../../MainScreenView/Views/MainScreenView.dart';
import '../../WelcomePage/WelcomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // ✅ الانتقال للصفحة التالية بعد 2 ثانية
    Future.delayed(Duration(seconds: 2), () {
      if (alSettings.currentUser == null) {
        FlutterStatusbarcolor.setNavigationBarColor(AppColors.secondaryColor);
        FlutterStatusbarcolor.setStatusBarColor(AppColors.secondaryColor);
      } else {
        FlutterStatusbarcolor.setNavigationBarColor(AppColors.basicColor);
        FlutterStatusbarcolor.setStatusBarColor(AppColors.basicColor);
      }

      Get.offAll(() => alSettings.currentUser != null ? const MainScreenView() : const WelcomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ الحصول على أبعاد الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.basicColor,
        statusBarColor: AppColors.basicColor,
        systemNavigationBarDividerColor: AppColors.basicColor,
      ),
      child: Scaffold(
        backgroundColor: AppColors.basicColor,
        body: Center(
          child: Image.asset(
            'assets/logos/logo.png',  // ✅ مسار صورة الشعار
            width: screenWidth * 0.5, // ✅ 50% من عرض الشاشة
            height: screenHeight * 0.25, // ✅ 25% من ارتفاع الشاشة
            fit: BoxFit.contain,  // ✅ لضمان تناسق الأبعاد
          ),
        ),
      ),
    );
  }
}
