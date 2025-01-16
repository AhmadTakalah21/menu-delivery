
// ignore_for_file: empty_catches

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/Pages/SignIn/Controllers/SingInControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';


class SingIn extends StatefulWidget {
  const SingIn({super.key});

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  SingInControllers controller = Get.put(SingInControllers());
  @override
  Widget build(BuildContext context) {

    return GetBuilder<SingInControllers>(init: controller,builder: (set){
      return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: AppColors.secondaryColor3,
        statusBarColor:  AppColors.secondaryColor3,
        systemNavigationBarColor:  AppColors.secondaryColor3
      ),
      child: Material(
        color: AppColors.secondaryColor3 ,
      child:SafeArea(
        child: Scaffold(
            body:Form(
              key: controller.login,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: SizedBox(
                    height: Get.height,
                    child: Container(

                      alignment: Alignment.center,
                      decoration:  BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          image: DecorationImage(
                            image: AssetImage(AppImages.background1),
                            fit: BoxFit.fill,
                          )
                      ),
                      child: Opacity(
                          opacity: controller.opacity.value.value,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale:  controller.transform.value.value,
                                child: Container(
                                  width: Get.width * .9,
                                  height: controller.validatorEmail.value?Get.width * 1.1: Get.width * 0.9,
                                  decoration: BoxDecoration(
                                    color:  Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SingleChildScrollView(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: Get.width/13,),
                                      Text(TranslationKeys.signIn.tr,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
                                      SizedBox(height: Get.width/12,),
                                      component1(hintText: TranslationKeys.userName.tr,isPassword:  false, isEmail: true,textEditingController: controller.email),
                                      SizedBox(height: Get.width/13,),
                                      component1(hintText:  TranslationKeys.password.tr,isPassword:  true,isEmail:  false,textEditingController: controller.password),
                                      SizedBox(height: Get.width/13,),

                                      SizedBox(width: Get.width*0.39,child:RoundedLoadingButton(
                                        height: Get.height*0.06,
                                        color: AppColors.basicColor,
                                        //color2: AppColors.basicColor,
                                        successColor: AppColors.basicColor,
                                          child: Text(TranslationKeys.signIn.tr, style: const TextStyle(color: Colors.white,)),
                                          controller: controller.btnController,
                                          onPressed: controller.stateLogin.value==1?(){
                                            FocusScopeNode currentFocus = FocusScope.of(context);
                                            if (currentFocus.canRequestFocus) {
                                              FocusScope.of(context).requestFocus( FocusNode());
                                            }
                                            controller.onPressedIconWithText();
                                          }:null,
                                        ))

                                      // SizedBox(width: Get.width*0.39,child:ALConstantsWidget.elevatedButton(
                                      //   text: TranslationKeys.signIn.tr,
                                      //   onPressed: controller.stateLogin.value==1?(){
                                      //     FocusScopeNode currentFocus = FocusScope.of(context);
                                      //     if (currentFocus.canRequestFocus) {
                                      //       FocusScope.of(context).requestFocus( FocusNode());
                                      //     }
                                      //     controller.onPressedIconWithText();
                                      //   }:null,)),

                                    ],
                                  )),
                                ),
                              ),
                            ],)
                      ),
                    ),
                  ),
                ),
              ),
            )),
      )));});
  }

  Widget component1({ required String hintText,required bool isPassword, required bool isEmail , required TextEditingController textEditingController }) {


    return Container(
      width: Get.width*0.84,
      height: !controller.validator.value ?Get.height*0.1: Get.height*0.06,
      child: ValueListenableBuilder<TextDirection>(
      valueListenable: controller.textDir,
      child: const SizedBox(),
      builder: (context, valueTextDirection, child) =>
      TextFormField(
        textDirection: valueTextDirection,
        controller: textEditingController,
        validator: (val) {
          if (val!.trim().isEmpty) {
            controller.validator.value=false;
            controller.validatorEmail.value=true;
            controller.updateController();
            return TranslationKeys.required.tr;
          }
          else if(isEmail)
          {

              controller.validatorEmail.value=false;
              controller.updateController();
              return null;
          }
          else {
            controller.validator.value=true;
            controller.updateController();
            return null;
          }
        },
        obscureText: isPassword && controller.visiblePassword.value,
        cursorColor: AppColors.secondaryColor,

        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(right: 10,left: 10),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: BorderSide(width: .8,color: Colors.redAccent.shade100)),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
          enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
          prefixIcon: isPassword && !alSettings.rTL.value ?InkWell(
            onTap: (){
              controller.visiblePassword.value = !controller.visiblePassword.value;
              controller.update();
            },
            child: Icon(
              controller.visiblePassword.value?CupertinoIcons.lock:CupertinoIcons.lock_open,
              color:  AppColors.grayColor,
            ),
          ):null,
          suffixIcon:  isPassword && alSettings.rTL.value ?InkWell(
            onTap: (){
              controller.visiblePassword.value = !controller.visiblePassword.value;
              controller.update();
            },
            child: Icon(
              controller.visiblePassword.value?CupertinoIcons.eye_slash_fill:CupertinoIcons.eye_fill,
              color:  AppColors.grayColor,
            ),
          ):null,
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          filled: true,
          fillColor: AppColors.whiteColor,
          hintStyle: const TextStyle(fontSize: 14, color: AppColors.grayColor),
        ),
        onChanged: (value){
          final dir = ALMethode.getDirection(value.trim());
          if (dir != valueTextDirection)
          {
            controller.textDir.value = dir;
          }
        },
      )),
    );
  }

}





class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection,
      ) {
    return child;
  }
}