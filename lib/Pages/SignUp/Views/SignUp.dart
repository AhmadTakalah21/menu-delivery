
// ignore_for_file: empty_catches

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/Pages/SignUp/Controllers/SignUpControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpControllers controller = Get.put(SignUpControllers());
  @override
  Widget build(BuildContext context) {

    return GetBuilder<SignUpControllers>(init: controller,builder: (set){
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
        color:  AppColors.secondaryColor3,
      child:SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.secondaryColor3,
            body:Form(
              key: controller.login,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: SizedBox(
                    height: Get.height,
                    child: Obx(()
                      {
                        switch (controller.pageState.value)
                        {
                          case 0:
                            {
                              return  loadingPage();
                            }
                          case 1:
                            {
                              return  Container(

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
                                    child:SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale:  controller.transform.value.value,
                                            child: Container(
                                              padding: EdgeInsets.only(bottom: 50),
                                              width: Get.width * .9,
                                              decoration: BoxDecoration(
                                                color:  Colors.transparent,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: SingleChildScrollView(child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: Get.width/13,),
                                                  Text(TranslationKeys.signUp.tr,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
                                                  SizedBox(height: Get.width/20,),
                                                  component1(hintText: TranslationKeys.userName.tr,isPassword:  false, isEmail: false,textEditingController: controller.email),
                                                  SizedBox(height: Get.width/20,),
                                                  component1(hintText: TranslationKeys.name.tr,isPassword:  false, isEmail: false,textEditingController: controller.name),
                                                  SizedBox(height: Get.width/20,),
                                                  component1(hintText:  TranslationKeys.phone.tr,isPhone:  true,isPassword:  false,isEmail:  false,textEditingController: controller.phone),
                                                  SizedBox(height: Get.width/20,),
                                      
                                      
                                      
                                                  Container(
                                                    width: Get.width*0.83,
                                                    height: Get.height*0.060,
                                                    child:  Padding(
                                                      padding:  EdgeInsets.only(top: Get.height*0.00),
                                                      child: CustomDropdown<String>.search(
                                                        maxlines: 5,
                                                        decoration: CustomDropdownDecoration(
                                                            listItemStyle: TextStyle(fontSize: 13),
                                                            headerStyle: TextStyle(fontSize: 13),
                                      
                                                            closedFillColor: const Color(0xFFF2F2F2),
                                                            closedBorderRadius: BorderRadius.circular(100),
                                                            closedBorder: Border.all(color: AppColors.grayColor,width: 0.5),
                                                            searchFieldDecoration: SearchFieldDecoration(
                                                              suffixIcon: (onClear){
                                                                return IconButton(splashRadius: 20,onPressed:  onClear, icon: const Icon(Icons.close,color: AppColors.basicColor,));
                                                              },
                                                              prefixIcon: const Icon(Icons.search,color: AppColors.basicColor,),
                                                            )
                                                        ),
                                      
                                                        noResultFoundText: TranslationKeys.notFound.tr,
                                      
                                                        closedHeaderPadding: EdgeInsets.only(top: Get.height*0.011,bottom: Get.height*0.011,right: Get.width*0.04,left: Get.width*0.04),
                                                        items: controller.cities.value.map((e) => e.name.toString()).toList(),
                                                        excludeSelected: false,
                                                        hintText:controller.citiesName.value,
                                      
                                                        onChanged: (value) {
                                                          controller.citiesId.value=controller.cities.value.where((element) => element.name==value).first.id.toString();
                                                          controller.citiesName.value =value;
                                                          controller.update();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                      
                                                  SizedBox(height: !controller.validator.value? Get.width/10: Get.width/18,),
                                                  Container(
                                                    width: Get.width*0.83,
                                                    height: Get.height*0.06,
                                                    child:  Padding(
                                                      padding:  EdgeInsets.only(top: Get.height*0.00),
                                                      child: CustomDropdown<String>.search(
                                                        maxlines: 5,
                                                        decoration: CustomDropdownDecoration(
                                                            listItemStyle: TextStyle(fontSize: 13),
                                                            headerStyle: TextStyle(fontSize: 13),
                                      
                                                            closedFillColor: const Color(0xFFF2F2F2),
                                                            closedBorderRadius: BorderRadius.circular(100),
                                                            closedBorder: Border.all(color: AppColors.grayColor,width: 0.5),
                                                            searchFieldDecoration: SearchFieldDecoration(
                                                              suffixIcon: (onClear){
                                                                return IconButton(splashRadius: 20,onPressed:  onClear, icon: const Icon(Icons.close,color: AppColors.basicColor,));
                                                              },
                                                              prefixIcon: const Icon(Icons.search,color: AppColors.basicColor,),
                                                            )
                                                        ),
                                      
                                                        noResultFoundText: TranslationKeys.notFound.tr,
                                      
                                                        closedHeaderPadding: EdgeInsets.only(top: Get.height*0.011,bottom: Get.height*0.011,right: Get.width*0.04,left: Get.width*0.04),
                                                        items: controller.gender.value.map((e) => e.name.toString()).toList(),
                                                        excludeSelected: false,
                                                        hintText:controller.genderName.value,
                                      
                                                        onChanged: (value) {
                                                          controller.genderId.value=controller.gender.value.where((element) => element.name==value).first.id.toString();
                                                          controller.genderName.value =value;
                                                          controller.update();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: !controller.validator.value? Get.width/10:Get.width/16,),
                                                  component1(hintText:  TranslationKeys.password.tr,isPassword:  true,isEmail:  false,textEditingController: controller.password),
                                                  SizedBox(height: Get.width/20,),

                                                  component2(hintText:  TranslationKeys.passwordConfirm.tr,isPassword:  true,isEmail:  false,textEditingController: controller.passwordConfirm),
                                                  SizedBox(height: Get.width/20,),
                                      
                                      
                                                  SizedBox(width: Get.width*0.39,child:RoundedLoadingButton(
                                                    height: Get.height*0.06,
                                                    color: AppColors.basicColor,
                                                    //color2: AppColors.basicColor,
                                                    successColor: AppColors.basicColor,
                                                    child: Text(TranslationKeys.signUp.tr, style: const TextStyle(color: Colors.white)),
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
                                                  //   text: TranslationKeys.signUp.tr,
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
                                        ],),
                                    )
                                ),
                              );
                            }
                          case 2:
                            {
                              return errorPage();
                            }
                          default:
                            return  Container(width: Get.width,height: Get.height,);
                        }
                   }),
                  ),
                ),
              ),
            )),
      )));});
  }

  Widget component1({bool? isPhone, required String hintText,required bool isPassword, required bool isEmail , required TextEditingController textEditingController }) {

    // return SizedBox(height:!controller.validator.value ?Get.width / 4.5: Get.width / 8,child: Padding(padding:  EdgeInsets.only(bottom: 0,top: 0,right: Get.width / 30,left:Get.width / 30 ),child:

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
            controller.validator.value=false;
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
        keyboardType: isPhone!=null ? TextInputType.phone: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(right: 10,left: 10,top: 0),
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
              !controller.visiblePassword.value?CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill,
              color:  AppColors.grayColor,
            ),
          ):null,
          border: InputBorder.none,
          hintMaxLines: 1,
          filled: true,
          fillColor: AppColors.whiteColor,
          hintText: hintText,
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
    // ));
  }

  Widget component2({bool? isPhone, required String hintText,required bool isPassword, required bool isEmail , required TextEditingController textEditingController }) {

    // return SizedBox(height:!controller.validator.value ? Get.width / 4.5 : Get.width / 8,child: Padding(padding:  EdgeInsets.only(bottom: 0,top: 0,right: Get.width / 30,left:Get.width / 30 ),child:

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
                    controller.validator.value=false;
                    controller.validatorEmail.value=false;
                    controller.updateController();
                    return null;
                  }
                  else if(val!=controller.password.text)
                  {
                    controller.validator.value=false;
                    controller.validatorEmail.value=false;
                    return TranslationKeys.passwordConfirm.tr;
                  }
                  else {
                    controller.validator.value=true;
                    controller.updateController();
                    return null;
                  }
                },
                obscureText: controller.visiblePassword2.value,
                cursorColor: AppColors.secondaryColor,
                keyboardType: isPhone!=null ? TextInputType.phone: isEmail ? TextInputType.emailAddress : TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(right: 10,left: 10),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: BorderSide(width: .8,color: Colors.redAccent.shade100)),
                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
                  enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
                  prefixIcon: isPassword && !alSettings.rTL.value ?InkWell(
                    onTap: (){
                      controller.visiblePassword2.value = !controller.visiblePassword2.value;
                      controller.update();
                    },
                    child: Icon(
                      controller.visiblePassword2.value?CupertinoIcons.lock:CupertinoIcons.lock_open,
                      color:  AppColors.grayColor,
                    ),
                  ):null,
                  suffixIcon:  isPassword && alSettings.rTL.value ?InkWell(
                    onTap: (){
                      controller.visiblePassword2.value = !controller.visiblePassword2.value;
                      controller.update();
                    },
                    child: Icon(
                      !controller.visiblePassword2.value?CupertinoIcons.eye_fill:CupertinoIcons.eye_slash_fill,
                      color:  AppColors.grayColor,
                    ),
                  ):null,
                  border: InputBorder.none,
                  hintMaxLines: 1,
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  hintText: hintText,
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
    )
    ;
  }

  Widget errorPage () {
    return ALConstantsWidget.errorServer(callBack: (){
      controller.onInit();
    });
  }
  Widget loadingPage () {
    return Container(decoration:BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background1),
          fit: BoxFit.fill,
        )
    ),child: Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),));
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