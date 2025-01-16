


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';



typedef CallBackPop = Future<void> Function();

class ALConstantsWidget {


  static Widget smartRefresh() {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.done,
          color: AppColors.secondaryColor,
        ),
        Container(
          width: 5.0,
        ),
        Text(TranslationKeys.refreshCompleted.tr, style: const TextStyle(color: AppColors.secondaryColor),
        )
      ],
    );
  }

  static Widget NotFoundData(String text,{double? size})  {
    return SizedBox(
      width: Get.width,
      height: size??Get.height,
      child: Center(child: Text(text,style: const TextStyle(fontSize: 14,color: Colors.grey,),textAlign: TextAlign.center,),),
    );
  }

  static Widget clLoading({required double width,required double height , Color? color}) {
    return Container(width: width,height: height,child:
    Platform.isAndroid? CircularProgressIndicator(color: Theme.of(Get.context!).primaryColorDark,strokeWidth: 1,backgroundColor: AppColors.basicColor,) :  CupertinoActivityIndicator(color: Theme.of(Get.context!).primaryColorDark),
    );
  }

  static Widget notFoundData(String text,{double? size})  {
    return SizedBox(
      width: Get.width,
      height: size??Get.height,
      child: Center(child: Text(text,style: const TextStyle(fontSize: 14,color: Colors.grey,),textAlign: TextAlign.center,),),
    );
  }




  static  awesomeDialog({required RoundedLoadingButtonController? controller,required Widget child , required String title ,required String btnCancelText , required String btnOkText ,required dynamic onPressed }){

    AwesomeDialog(
      context: Get.context!,
      keyboardAware: true,
      dismissOnBackKeyPress: true,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      btnCancelText: btnCancelText,
      btnOkText:btnOkText,
      headerAnimationLoop: false,
      title:title,
      titleTextStyle:const TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w900),
      padding: const EdgeInsets.all(16.0),
      btnCancel:controller==null ? elevatedButton(onPressed: onPressed, text: btnOkText) : elevatedButtonAnimation(controller: controller!,onPressed: onPressed, text: btnOkText),
      btnOk: elevatedButton2(text: btnCancelText),
      body: child
    ).show();

  }


  static Widget elevatedButton({required var onPressed,required String text}) {
    return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.secondaryColor,
              AppColors.secondaryColor
            ],
          ),
          borderRadius:  BorderRadius.circular(100),
        ),
        child:ElevatedButton(onPressed: onPressed,style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: AppColors.secondaryColor.withOpacity(0.5),
          shadowColor: Colors.transparent,
          padding: EdgeInsets.only(top: Get.height*0.005,bottom: Get.height*0.005,left: 10,right: 10),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ), child:  Text(text.tr),));
  }


  static Widget elevatedButtonAnimation({required var onPressed,required String text,required RoundedLoadingButtonController? controller}) {
    return controller==null ? elevatedButton(onPressed: onPressed, text: text) :RoundedLoadingButton(
      successColor: AppColors.basicColor,
      color: AppColors.secondaryColor,
      //color2: AppColors.secondaryColor,
      borderRadius:  100,
      controller: controller,
      onPressed:(){
        FocusScopeNode currentFocus = FocusScope.of(Get.context!);
        if (currentFocus.canRequestFocus) {
          FocusScope.of(Get.context!).requestFocus( FocusNode());
        }
        onPressed();
      },

      child: Text(text.tr, style: const TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),
    );
  }




  static Widget elevatedButton3({required var onPressed,required String text,bool? noBackGround}) {
    return Container(
        decoration: BoxDecoration(
            color:noBackGround!=null?Colors.transparent:AppColors.basicColor,
          borderRadius:  BorderRadius.circular(15),
        ),
        child:ElevatedButton(onPressed: onPressed,style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.only(top: Get.height*0.002,bottom: Get.height*0.002),

          shape: RoundedRectangleBorder(
            side: noBackGround!=null?BorderSide(color: AppColors.readColor,width: 0.5):BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
        ), child:  Text(text.tr,style: TextStyle(color: noBackGround!=null?Colors.black:Colors.white)),));
  }

  static Widget elevatedButton2({required String text}) {
    return Container(
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(100),
          border:Border.all(color: AppColors.grayColor,width: 0.5)
        ),
        child:ElevatedButton(onPressed: (){Get.back();},style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.only(top: Get.height*0.014,bottom: Get.height*0.014),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ), child:  Text(text.tr,style: const TextStyle(color: Colors.black),),));
  }

  static Widget elevatedButtonWithStyle({required var onTap,required String text,required Color colors , required Color textColor}) {
    return ElevatedButton(onPressed: (){
      onTap();
      },style: ElevatedButton.styleFrom(
          backgroundColor:colors,
          elevation: 2,
          shadowColor: colors,
          padding: EdgeInsets.only(top: Get.height*0.010,bottom: Get.height*0.010,left: Get.height*0.04,right: Get.height*0.04),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ), child:  Text(text.tr,style:  TextStyle(color: textColor,fontWeight: FontWeight.w500),));
  }

  static Future<void> showDialogIosOrAndroidThButton({required String content, required String? textTHButton ,required String? textTowButton,required CallBackPop? onPressOKButton , required CallBackPop? onPressCancelButtonTh,  bool? delete}) async{

    if(Platform.isIOS) {
      await showCupertinoDialog(

          context: Get.context!, builder: (_)=>
          CupertinoAlertDialog(
            actions: [
                CupertinoDialogAction(textStyle: const TextStyle(color:AppColors.grayColor),onPressed:(){
                  Get.back();
                },child:  Text(TranslationKeys.cancel.tr),),
              CupertinoDialogAction(textStyle: const TextStyle(color:AppColors.secondaryColor),onPressed:onPressCancelButtonTh?? (){
                Get.back();
              },child:  Text(TranslationKeys.sendOrder.tr),),
              CupertinoDialogAction(textStyle:  TextStyle(color:  delete!=null ?Colors.redAccent : AppColors.basicColor,fontSize: 18),onPressed:onPressOKButton?? (){
                Get.back();
              },child:  Text(delete!=null ?TranslationKeys.delete.tr:TranslationKeys.ok.tr),),

            ],
            title:  Text(TranslationKeys.confirm.tr),
            content:Text(content,style:TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 22)),));
    }
    else {
      await Get.defaultDialog(
        actions:[
          TextButton(
              style:  ButtonStyle(
                  overlayColor:  MaterialStateProperty.all(Colors.redAccent.withOpacity(0.1)),
                  foregroundColor: MaterialStateProperty.all(Colors.redAccent)),
              onPressed:onPressOKButton?? (){
                Get.back();
              },child:  Text(TranslationKeys.delete.tr,style:   TextStyle(color: Colors.redAccent,fontSize: 18,
            fontFamily: 'CM Sans Serif',
          ))),




          TextButton(onPressed:onPressCancelButtonTh?? (){
            Get.back();
          },
              style:  ButtonStyle(
                  overlayColor:  MaterialStateProperty.all(AppColors.secondaryColor.withOpacity(0.1)),
                  foregroundColor: MaterialStateProperty.all(AppColors.secondaryColor))
              ,child:  Text(TranslationKeys.sendOrder.tr,style:  const TextStyle(color: AppColors.secondaryColor,
                fontFamily: 'CM Sans Serif',
                fontSize: 16.0,))),


          TextButton(onPressed:(){
            Get.back();
          },
              style:  ButtonStyle(
                  overlayColor:  MaterialStateProperty.all(AppColors.grayColor.withOpacity(0.1)),
                  foregroundColor: MaterialStateProperty.all(AppColors.grayColor))
              ,child:  Text(TranslationKeys.cancel.tr,style:  const TextStyle(color: AppColors.grayColor,
                fontFamily: 'CM Sans Serif',
                fontSize: 16.0,))),



        ],
        title:TranslationKeys.confirm.tr,
        titleStyle:  TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 22),
        content: Text(content,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 16)),
        contentPadding: const EdgeInsets.all(18),
        titlePadding: const EdgeInsets.only(top: 25),

      );
    }
  }



  static Future<void> showDialogIosOrAndroid({String ?title ,required String content, String? textCancelButton ,required CallBackPop? onPressOKButton , CallBackPop? onPressCancelButton, required bool towButton, bool? delete}) async{

    if(Platform.isIOS) {
      await showCupertinoDialog(

          context: Get.context!, builder: (_)=>
          CupertinoAlertDialog(
            actions: [
              if(towButton)
                CupertinoDialogAction(textStyle: const TextStyle(color:AppColors.grayColor),onPressed:onPressCancelButton?? (){
                  Get.back();
                },child:  Text(TranslationKeys.cancel.tr),),
              CupertinoDialogAction(textStyle:  TextStyle(color:  delete!=null ?Colors.redAccent : AppColors.basicColor,fontSize: 18),onPressed:onPressOKButton?? (){
                Get.back();
              },child:  Text(delete!=null ?TranslationKeys.delete.tr:TranslationKeys.ok.tr),),

            ],
            title:  Text(title??TranslationKeys.confirm.tr),
            content:Text(content,style:TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 22)),));
    }
    else {
      await Get.defaultDialog(
        actions:[
          if(towButton)
            TextButton(onPressed:onPressCancelButton?? (){
              Get.back();
            },
                style:  ButtonStyle(
                    overlayColor:  MaterialStateProperty.all(AppColors.grayColor.withOpacity(0.1)),
                    foregroundColor: MaterialStateProperty.all(AppColors.grayColor))
                ,child:  Text(textCancelButton??TranslationKeys.cancel.tr,style:  const TextStyle(color: AppColors.grayColor,
              fontFamily: 'CM Sans Serif',
              fontSize: 16.0,))),
          TextButton(
              style:  ButtonStyle(
                  overlayColor:  MaterialStateProperty.all(delete!=null ?Colors.redAccent.withOpacity(0.1) :AppColors.basicColor.withOpacity(0.1)),
                  foregroundColor: MaterialStateProperty.all(delete!=null ?Colors.redAccent :AppColors.basicColor)),
              onPressed:onPressOKButton?? (){
                Get.back();
              },child:  Text(delete!=null ?TranslationKeys.delete.tr:TranslationKeys.ok.tr,style:   TextStyle(color: delete!=null ?Colors.redAccent : AppColors.basicColor,fontSize: 18,
            fontFamily: 'CM Sans Serif',
            ))),
        ],
        title:title??TranslationKeys.confirm.tr,
        titleStyle:  TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 22),
        content: Text(content,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black,fontSize: 16)),
        contentPadding: const EdgeInsets.all(18),
        titlePadding: const EdgeInsets.only(top: 25),

      );
    }
  }


  static Widget errorServer({required var callBack,Color? iconColor,Color? textColor}) {
    return Container(
      alignment: Alignment.center,
      width: Get.width,
      height: Get.height,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:                                [
            Icon(MdiIcons.cloudLock,color:AppColors.grayColor,size: Get.width/3),
            Text(TranslationKeys.noConnection.tr,style: TextStyle(fontSize: 17,color: textColor?? Colors.black,decoration: TextDecoration.none,fontFamily: 'CM Sans Serif',fontWeight: FontWeight.w400)),
            const SizedBox(height: 15,),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                 AppColors.basicColor,
                AppColors.basicColor
              ],
            ),
            borderRadius:  BorderRadius.circular(100),
          ),
          child:ElevatedButton(onPressed: callBack,style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ), child:  Text(TranslationKeys.tryAgain.tr),))
          ],
        ),
      ),
    );
  }



  static Widget loading({required double width,required double height , Color? color}) {
    return   Container(width: width,height: height,child: Padding(
      padding: const EdgeInsets.all(1.0),
      child:  Container(child:
      Platform.isAndroid? const CircularProgressIndicator(color: AppColors.grayColor,strokeWidth: 1,backgroundColor: AppColors.whiteColor,) :  CupertinoActivityIndicator(radius: 15),
      ),
    ));
  }

  // static Future<void> showDialogIosOrAndroid({Widget? contentWidget, String? id,String? dataOverLap,bool? subStr, String? title, String? content,required String? textOKButton , String? textCancelButton ,required CallBackPop? onPressOKButton , CallBackPop? onPressCancelButton, required bool towButton, bool? delete}) async{
  //
  //   if(Platform.isIOS) {
  //     await showCupertinoDialog(
  //         context: Get.context!, builder: (_)=>
  //         CupertinoAlertDialog(
  //           actions: [
  //             if(towButton)
  //               CupertinoDialogAction(child:  Text(textCancelButton??TranslationKeys.cancel.tr),textStyle: TextStyle(color:AppColors.basicColor),onPressed:onPressCancelButton?? (){
  //                 Get.back();
  //               },),
  //             CupertinoDialogAction(child:  Text(textOKButton??TranslationKeys.ok.tr),textStyle:  TextStyle(color:  delete!=null ?Colors.redAccent : Colors.blue),onPressed:onPressOKButton?? (){
  //               Get.back();
  //             },),
  //
  //           ],
  //           title:  Text(title??TranslationKeys.info.tr),
  //           content:   contentWidget??Text(content!),));
  //   }
  //   else {
  //     await Get.defaultDialog(
  //       actions:[
  //         if(towButton)
  //           TextButton(onPressed:onPressCancelButton?? (){
  //             Get.back();
  //           },child:  Text(textCancelButton??TranslationKeys.cancel.tr,style:  TextStyle(color: AppColors.basicColor,
  //             fontFamily: 'CM Sans Serif',
  //             fontSize: 16.0,))),
  //         TextButton(
  //             style:  ButtonStyle(
  //                 overlayColor:  MaterialStateProperty.all(AppColors.basicColor.withOpacity(0.1)),
  //                 foregroundColor: MaterialStateProperty.all(AppColors.basicColor)),
  //             onPressed:onPressOKButton?? (){
  //               Get.back();
  //             },child:  Text(textOKButton??TranslationKeys.ok.tr,style:   TextStyle(color: delete!=null ?Colors.redAccent : AppColors.basicColor,
  //           fontFamily: 'CM Sans Serif',
  //           fontSize: 16.0,))),
  //       ],
  //       title:title?? TranslationKeys.info.tr,
  //       titleStyle: clSettings.isDark.value? Theme.of(Get.context!).textTheme.subtitle2!.copyWith(fontSize: 18):Theme.of(Get.context!).textTheme.subtitle1,
  //       content: contentWidget?? Text(content!,textAlign: TextAlign.center,style: clSettings.isDark.value? Theme.of(Get.context!).textTheme.subtitle2!.copyWith(fontSize: 16):Theme.of(Get.context!).textTheme.subtitle1),
  //       contentPadding: const EdgeInsets.all(18),
  //       titlePadding: const EdgeInsets.only(top: 25),
  //
  //     );
  //   }
  // }

  // static Future<void> slidingBottomSheet({required Widget child, bool? withBlockApp,double? minHeight ,double? initialSnap, bool? awaitFuture}) async{
  //   await SystemChannels.textInput.invokeMethod('TextInput.hide');
  //   FlutterStatusbarcolor.setStatusBarColor(clSettings.isDark.value? AppColors.thColor : Colors.transparent);
  //    FlutterStatusbarcolor.setNavigationBarColor(clSettings.isDark.value? AppColors.thColor :Colors.white);
  //
  //   await showSlidingBottomSheet(
  //       Get.context!,
  //       builder: (ctx) => SlidingSheetDialog(
  //           minHeight: 10,
  //           headerBuilder:(context, state) => Material(
  //               color: Theme.of(context).colorScheme.background,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: Theme.of(context).colorScheme.background,width: 0.0),
  //                   color: Theme.of(context).colorScheme.background,),
  //                 width: Get.width,
  //                 height: 26,
  //                 padding: const EdgeInsets.all(12),
  //                 alignment: Alignment.center,
  //                 child: Container(
  //                   width:Get.width*0.25,
  //                   height: 5,
  //                   decoration: const BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(30)),
  //                       color: AppColors.basicColor),
  //                 ),
  //               )),
  //           cornerRadius: 20,
  //           avoidStatusBar: true,
  //           border: Border.all(color: Theme.of(Get.context!).colorScheme.background,width: 0.0),
  //           snapSpec: const SnapSpec(initialSnap: 0.4, snappings: [0.4,0.9],),
  //           builder: (BuildContext context,state) {
  //             return   Material(color:  clSettings.isDark.value?AppColors.thColor:Colors.white,child: child,);})
  //   ).then((value) {
  //     FlutterStatusbarcolor.setStatusBarColor(clSettings.isDark.value? AppColors.secondaryColor : Colors.transparent);
  //     FlutterStatusbarcolor.setNavigationBarColor(clSettings.isDark.value? AppColors.secondaryColor :Colors.white);
  //   });
  // }

}