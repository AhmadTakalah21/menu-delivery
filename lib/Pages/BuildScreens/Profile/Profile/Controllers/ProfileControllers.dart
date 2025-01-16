

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ClassModel/ProfileModel.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Repositories/CartRepositories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Profile/Repositories/ProfileRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/LocalConfigration/LocalString.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class ProfileControllers extends GetxController
{
  RoundedLoadingButtonController btnController =  RoundedLoadingButtonController();
  TextEditingController password= TextEditingController();
  TextEditingController passwordOld= TextEditingController();
  TextEditingController chickPassword= TextEditingController();
  GlobalKey<FormState> form = GlobalKey<FormState>();
  ValueNotifier<TextDirection> passwordTextDirection = ValueNotifier(TextDirection.ltr);
  ValueNotifier<TextDirection> passwordCTextDirection = ValueNotifier(TextDirection.ltr);
  RxInt pageState=1.obs;
  RxInt pageStateCart=0.obs;
  RxBool isSaveProfile=false.obs;
  late List<ProfileModel> profile ;
  String groupValue='';
  TextEditingController name=TextEditingController();
  TextEditingController phone=TextEditingController();
  ProfileRepositories repositories  =ProfileRepositories();
  Future<void> display_profile() async{
    pageState.value=0;


    if(await repositories.display_profile())
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        alSettings.currentUser!.fullName=data['name'];
        alSettings.currentUser!.userName=data['user_name'];
        alSettings.currentUser!.phone=data['phone'];

        name.text=alSettings.currentUser!.fullName.toString();
        phone.text=alSettings.currentUser!.phone.toString();
        profile=[
          ProfileModel(title: alSettings.currentUser!.userName.toString(),type:ProfileModelType.title,styleTypeType: ProfileModelStyleType.title ),
          ProfileModel(title: 'اعدادات الحساب',type:ProfileModelType.title,styleTypeType: ProfileModelStyleType.title ),
          ProfileModel(title: alSettings.currentUser!.fullName.toString(),type:ProfileModelType.title,styleTypeType: ProfileModelStyleType.textForm,controller: name ),
          ProfileModel(title: alSettings.currentUser!.phone.toString(),type:ProfileModelType.title,styleTypeType: ProfileModelStyleType.textForm,controller: phone,withPhone: true ),
          ProfileModel(withBorder: true,title: 'تغير كلمة المرور',type:ProfileModelType.changePassword,styleTypeType: ProfileModelStyleType.onTap ),
          ProfileModel(title: 'طلباتي',type:ProfileModelType.title,styleTypeType: ProfileModelStyleType.onTap ),
          ProfileModel(title: 'المحافظة',type:ProfileModelType.title,styleTypeType: ProfileModelStyleType.title ),
          ProfileModel(title: '',type:ProfileModelType.title,styleTypeType: ProfileModelStyleType.dropDown ),
          ProfileModel(title: TranslationKeys.logOut,type:ProfileModelType.logOut,styleTypeType: ProfileModelStyleType.logOut ),
        ];
      }
      pageState.value=1;
    }
    else
    {
      pageState.value=2;
    }
  }

  Future<void> saveProfile() async{
    isSaveProfile.value=true;

    Map<String,String> body ={
      'name':name.text.trim(),
      'phone':phone.text.trim(),
      'city_id':alSettings.currentUser!.citiesId.toString(),
    };
    await repositories.update_profile(body:body );
    isSaveProfile.value=false;
    onInit();

  }



  Future<void> onPressProfileButton({required ProfileModelType type}) async{

    switch(type)
    {
      case ProfileModelType.changePassword:
        {

          await ALConstantsWidget.awesomeDialog(
              controller: btnController,
              child:  SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                      child: StatefulBuilder(
                          builder: (context, State) {

                            return  Form(
                              key:form,
                              child: Column(
                                  children: [
                                    Text(TranslationKeys.changePassword.tr,style: const TextStyle(fontSize: 24,color: AppColors.grayColor,fontWeight: FontWeight.w800),),
                                    SizedBox(height: Get.height*0.025,),
                                    ValueListenableBuilder<TextDirection>(
                                        valueListenable: passwordCTextDirection,
                                        child: const SizedBox(),
                                        builder: (context, valueTextDirection, child) =>
                                            TextFormField(
                                                textDirection: valueTextDirection,
                                                validator: (val){
                                                   if (val!.trim().isEmpty)
                                                     {
                                                    return TranslationKeys.required.tr;
                                                  }
                                                  else {
                                                    return null;
                                                  }
                                                },
                                                enabled: true,
                                                controller: passwordOld,
                                                textInputAction: null,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                    contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                                                    hintStyle: TextStyle(color: AppColors.grayColor,fontSize: 13),                                                                  alignLabelWithHint: true,
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    hintText: 'كلمة المرور القديمة'
                                                ),
                                                style: const TextStyle(color: Colors.black,fontSize: 18))),
                                    SizedBox(height: Get.height*0.025,),
                                    ValueListenableBuilder<TextDirection>(
                                        valueListenable: passwordTextDirection,
                                        child: const SizedBox(),
                                        builder: (context, valueTextDirection, child) => TextFormField(
                                                textDirection: valueTextDirection,
                                                validator: (val){
                                                  if (val!.trim().isEmpty) {
                                                    return TranslationKeys.required.tr;
                                                  }
                                                  else {
                                                    return null;
                                                  }
                                                },
                                                enabled: true,
                                                controller: password,
                                                textInputAction: null,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                    contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                                                    hintStyle: TextStyle(color: AppColors.grayColor,fontSize: 13),                                                                  alignLabelWithHint: true,
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    hintText: TranslationKeys.newPassword.tr
                                                ),
                                                style: const TextStyle(color: Colors.black,fontSize: 18))),
                                    SizedBox(height: Get.height*0.025,),
                                    ValueListenableBuilder<TextDirection>(
                                        valueListenable: passwordCTextDirection,
                                        child: const SizedBox(),
                                        builder: (context, valueTextDirection, child) =>
                                            TextFormField(
                                                textDirection: valueTextDirection,
                                                validator: (val){
                                                  if (val!.trim().isEmpty) {
                                                    return TranslationKeys.required.tr;
                                                  }
                                                  else {
                                                    return null;
                                                  }
                                                },
                                                enabled: true,
                                                controller: chickPassword,
                                                textInputAction: null,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                    contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                                                    hintStyle: TextStyle(color: AppColors.grayColor,fontSize: 13),                                                                  alignLabelWithHint: true,
                                                    border: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors.black, width: 0.5),
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    hintText: TranslationKeys.chickPassword.tr
                                                ),
                                                style: const TextStyle(color: Colors.black,fontSize: 18))),


                                    SizedBox(height: Get.height*0.03,)
                                  ]),
                            );}))),
              title: TranslationKeys.choseLanguage.tr,
              btnCancelText: TranslationKeys.cancel,
              btnOkText: TranslationKeys.confirm.tr,
              onPressed: ()async{
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                var states = form.currentState;
                if (states!.validate()) {
                  await SystemChannels.textInput.invokeMethod('TextInput.hide');

                  Map<String,String> body ={
                    'old_password':passwordOld.text.trim(),
                    'new_password':password.text.trim(),
                    'password_confirmation':chickPassword.text.trim(),
                  };
                  if(await repositories.update_password(body: body))
                  {

                    btnController.success();
                    Timer(const Duration(seconds: 1), () {
                    Get.back();
                    },
                    );
                  }
                  else
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
                  }
                  // });

                }
                else
                {
                  btnController.reset();
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                }
              });
        }
      case ProfileModelType.logOut:
        {
          await ALMethode.logout();
          break;
        }
      case ProfileModelType.title:
        {
          FlutterStatusbarcolor.setNavigationBarColor(AppColors.whiteColor);
          FlutterStatusbarcolor.setStatusBarColor(AppColors.whiteColor);
          Get.toNamed(Routes.OrderHistory)!.then((value) async {
            FlutterStatusbarcolor.setNavigationBarColor(AppColors.basicColor);
            FlutterStatusbarcolor.setStatusBarColor(AppColors.whiteColor);
          });

          break;
        }
      case ProfileModelType.changePhone:
        // TODO: Handle this case.
      case ProfileModelType.changeName:
        // TODO: Handle this case.
      case ProfileModelType.changeCity:
        // TODO: Handle this case.
    }

  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    display_profile();

  }
}
