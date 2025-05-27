import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/Model/Model/CurrentUser.dart';
import 'package:shopping_land_delivery/Pages/SignIn/Repositories/SingInRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ استيراد LocationController بشكل صحيح
import '../../../Services/location_services/location_service.dart';
import '../../../Services/location_services/location_service_controller.dart';

class SingInControllers extends GetxController with GetSingleTickerProviderStateMixin {
  // ✅ تعريف LocationController كمتحول عام ليستدعى في أي مكان داخل الكلاس
  // final LocationController _locationController = Get.put(LocationController());

  late Rx<AnimationController> controller;
  late Rx<Animation<double>> animation;
  late Rx<Animation<double>> opacity;
  late Rx<Animation<double>> transform;
  late ScrollController scrollController;
  late GlobalKey<ScaffoldState> scaffoldKey;
  late TextEditingController email;
  late TextEditingController password;
  RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  RxBool validator = true.obs;
  RxBool validatorEmail = false.obs;
  RxBool isCatchError = false.obs;
  BuildContext? context;
  late GlobalKey<FormState> login;
  AnimationController? animationController;
  RxInt stateLogin = 1.obs;
  RxBool keyboardVisibility = false.obs;
  RxBool visiblePassword = true.obs;
  late ValueNotifier<TextDirection> textDir;

  SingInControllers() {
    textDir = ValueNotifier(alSettings.currentUser != null && alSettings.currentUser!.locale != 'ar'
        ? TextDirection.ltr
        : TextDirection.rtl);

    scrollController = ScrollController();
    scaffoldKey = GlobalKey<ScaffoldState>();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    ).obs;

    login = GlobalKey<FormState>();

    opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller.value,
      curve: Curves.ease,
    )).obs;

    opacity.value.addListener(() {
      update();
    });

    transform = Tween<double>(begin: 2, end: 1).animate(CurvedAnimation(
      parent: controller.value,
      curve: Curves.fastLinearToSlowEaseIn,
    )).obs;

    controller.value.forward();

    email = TextEditingController();
    password = TextEditingController();
  }

  void updateController() {
    update();
  }

  void onPressedIconWithText() async {
    SingInRepositories repositories = SingInRepositories();
    try {
      var states = login.currentState;
      if (states!.validate()) {
        await SystemChannels.textInput.invokeMethod('TextInput.hide');

        // ✅ متابعة عملية تسجيل الدخول
        bool loginSuccess = await repositories.login(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        if (loginSuccess) {
          var data = json.decode(json.decode(repositories.message.data));

          // ✅ حفظ بيانات المستخدم
          alSettings.currentUser = CurrentUser(locale: 'ar');
          alSettings.currentUser!.userId = data['id'].toString();
          alSettings.currentUser!.userName = data['user_name'];
          alSettings.currentUser!.apiKey = data['token'];
          alSettings.currentUser!.locale = 'ar';

          await ALMethode.setUserInfo(data: alSettings.currentUser!);

          String userId = alSettings.currentUser!.userId!;
          String token = alSettings.currentUser!.apiKey!;

          await saveUserData(userId, token);

          // ✅ التحقق من تفعيل خدمة الموقع بعد تسجيل الدخول
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            btnController.error();
            ALMethode.showToast(
              title: "❌ خطأ",
              message: "يجب تفعيل خدمة الموقع للمتابعة",
              type: ToastType.error,
              context: Get.context!,
            );
            Timer(const Duration(seconds: 1), () {
              btnController.reset();
            });
            return;
          }

          // ✅ التحقق من إذن الوصول إلى الموقع
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              btnController.error();
              ALMethode.showToast(
                title: "🚫 خطأ",
                message: "تم رفض إذن الموقع، يرجى السماح به للمتابعة",
                type: ToastType.error,
                context: Get.context!,
              );
              Timer(const Duration(seconds: 1), () {
                btnController.reset();
              });
              return;
            }
          }

          if (permission == LocationPermission.deniedForever) {
            btnController.error();
            ALMethode.showToast(
              title: "❌ خطأ",
              message: "تم رفض إذن الموقع بشكل دائم، قم بتفعيله من الإعدادات",
              type: ToastType.error,
              context: Get.context!,
            );
            Timer(const Duration(seconds: 1), () {
              btnController.reset();
            });
            return;
          }

          final locationController = Get.put(LocationController());
          locationController.fetchUserLocationAndSend(token, userId);
          locationController.startListeningToLocationChanges(token, userId);



          // ✅ فتح WebSocket بعد تسجيل الدخول
          LocationService locationService = LocationService();
          locationService.initMainWebSocket();

          btnController.success();
          Timer(const Duration(seconds: 1), () {
            Get.offAllNamed(Routes.MAIN_SCREEN);
          });
        } else {
          btnController.error();
          ALMethode.showToast(
            title: TranslationKeys.somethingWentWrong.tr,
            message: repositories.message.description ?? TranslationKeys.errorEmail.tr,
            type: ToastType.error,
            context: Get.context!,
          );
          Timer(const Duration(seconds: 1), () {
            btnController.reset();
          });
        }
      } else {
        btnController.reset();
        await SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    } catch (e) {
      btnController.error();
      ALMethode.showToast(
        title: TranslationKeys.somethingWentWrong.tr,
        message: "حدث خطأ أثناء تسجيل الدخول: $e",
        type: ToastType.error,
        context: Get.context!,
      );
      Timer(const Duration(seconds: 1), () {
        btnController.reset();
      });
    }
  }










  Future<void> saveUserData(String userId, String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('token', token); // تأكد من تخزين التوكن الجديد

      // التحقق من الحفظ
      String? savedUserId = prefs.getString('userId');
      String? savedToken = prefs.getString('token');

      if (savedUserId != null && savedToken != null) {
        print('✅ تم حفظ بيانات المستخدم بنجاح: userId = $savedUserId, token = $savedToken');
      } else {
        print('❌ فشل في حفظ بيانات المستخدم');
      }
    } catch (e) {
      print('⚠️ خطأ أثناء حفظ بيانات المستخدم: $e');
    }
  }








  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    controller.close();
    opacity.close();
    transform.close();
    scrollController.dispose();
  }
}
