
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/Model/Model/Cities.dart';
import 'package:shopping_land_delivery/Model/Model/CurrentUser.dart';
import 'package:shopping_land_delivery/Pages/SignIn/Repositories/SingInRepositories.dart';
import 'package:shopping_land_delivery/Pages/SignUp/Repositories/SingUpRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';
import 'package:uuid/uuid.dart';

class SignUpControllers extends GetxController with GetSingleTickerProviderStateMixin
{
  late Rx<AnimationController> controller;
  late Rx<Animation<double>> animation;
  late Rx<Animation<double>> opacity;
  late Rx<Animation<double>> transform;
  RxString citiesName =''.obs;
  RxString citiesId=''.obs;
  RxString genderName =''.obs;
  RxString genderId=''.obs;

  late ScrollController scrollController;
  late  GlobalKey<ScaffoldState> scaffoldKey;
  RxList<Cities> cities =<Cities>[].obs;
  RxList<Cities> gender =<Cities>[].obs;
  late TextEditingController email ;
  late TextEditingController password ;
  late TextEditingController name ;
  late TextEditingController phone ;
  late TextEditingController passwordConfirm ;

   RoundedLoadingButtonController btnController =  RoundedLoadingButtonController();
  RxBool validator= true.obs;
  RxInt pageState=0.obs;
  RxBool validatorEmail= false.obs;
  RxBool isCatchError= false.obs;
  BuildContext? context;
  late GlobalKey<FormState> login ;
  AnimationController? animationController;
  RxInt stateLogin= 1.obs;
  RxBool keyboardVisibility=false.obs;
  RxBool visiblePassword = true.obs;
  RxBool visiblePassword2 = true.obs;
 late ValueNotifier<TextDirection> textDir ;
  SignUpControllers() {

    gender=[
      Cities(id: Uuid().v4().toString(),name: 'ذكر'),
      Cities(id: Uuid().v4().toString(),name: 'انثى')
    ].obs;
    genderName.value='الجنس';
    textDir = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);
    scrollController=ScrollController();
    scaffoldKey = GlobalKey<ScaffoldState>();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    ).obs;
    login = GlobalKey<FormState>();
    opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: controller.value,
        curve: Curves.ease,
      ),).obs;
    opacity.value.addListener(() {
      update();
    });
    transform = Tween<double>(begin: 2, end: 1).animate(CurvedAnimation(
        parent: controller.value,
        curve: Curves.fastLinearToSlowEaseIn,
      ),).obs;
    controller.value.forward();
    email=TextEditingController();
    password=TextEditingController();
    phone =TextEditingController();
    passwordConfirm =TextEditingController();
    name =TextEditingController();


  }

  void  updateController(){
    update();
  }

  void onPressedIconWithText() async {
    SingUpRepositories repositories =SingUpRepositories();
  try{
    var states = login.currentState;
    if (states!.validate()) {
      Map<String,String> body={
        'user_name':email.text.trim(),
        'password':password.text.trim(),
        'password_confirmation':passwordConfirm.text.trim(),
        'name':name.text.trim(),
        'gender':genderName.isEmpty?gender.first.name.toString():genderName.trim(),
        'city_id':cities.isEmpty?cities.first.id.toString():citiesId.trim(),
        'phone':phone.text.trim(),
      };
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      // await FirebaseMessaging.instance.getToken().then((token) async{
        if(await repositories.register_customer(body: body))
        {
          btnController.success();
          Timer(const Duration(seconds: 1), () {
            btnController.reset();
            Get.offNamed(Routes.SingIn);
          },
          );
        }
        else
        {
          btnController.error();
          ALMethode.showToast(
              title: TranslationKeys.somethingWentWrong.tr,
              message: repositories.message.description??TranslationKeys.errorEmail.tr,
              type: ToastType.error, context: context!);
          Timer(
            const Duration(seconds: 1),
                () {
              btnController.reset();
            },
          );
        }
      // });

    }
    else
    {
      btnController.reset();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
  catch(e)
    {
      btnController.error();
      ALMethode.showToast(
          title: TranslationKeys.somethingWentWrong.tr,
          message: repositories.message.description??TranslationKeys.errorEmail.tr,
          type: ToastType.error, context: Get.context!);
      Timer(
        const Duration(seconds: 1),
            () {
          btnController.reset();
        },
      );
      Timer(
        const Duration(seconds: 1),
            () {
          btnController.reset();
        },
      );
    }
  }

  Future<void> display_all_cities() async{
    pageState.value=0;
    SingUpRepositories repositories  =SingUpRepositories();
    if(await repositories.display_all_cities())
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        cities.value =dataCitiesFromJson(json.encode(data['cities']));
        citiesName.value=cities.first.name.toString();
        citiesId.value=cities.first.id.toString();
      }
      pageState.value=1;
    }
    else
    {
      pageState.value=2;
    }
  }




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    display_all_cities();


  }

  @override
  void onClose() {
    // TODO: implement onClose
    controller.close();
    opacity.close();
    transform.close();
    scrollController.dispose();
    super.onClose();

  }


}