import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

// ✅ استيراد LocationController بشكل صحيح
import '../../../Services/location_services/location_service_controller.dart';

class SingInControllers extends GetxController with GetSingleTickerProviderStateMixin {
  // ✅ تعريف LocationController كمتحول عام ليستدعى في أي مكان داخل الكلاس
  final LocationController _locationController = Get.put(LocationController());

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

  // ✅ تعديل الدالة لتستدعي الموقع بشكل صحيح بعد تسجيل الدخول
  // ✅ تسجيل الدخول وتفعيل تتبع الموقع المستمر
  void onPressedIconWithText() async {
    SingInRepositories repositories = SingInRepositories();
    try {
      var states = login.currentState;
      if (states!.validate()) {
        await SystemChannels.textInput.invokeMethod('TextInput.hide');

        if (await repositories.login(email: email.text.trim(), password: password.text.trim())) {
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

          // ✅ بدء تتبع الموقع بشكل مستمر
          _locationController.startLocationTracking(userId, token);

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
            context: context!,
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
