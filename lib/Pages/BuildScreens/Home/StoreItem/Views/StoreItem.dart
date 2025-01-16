



import 'dart:io';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/ALWidget/CustomTextInput.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/StoreItem/Controllers/StoreItemControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class StoreItem extends GetView<StoreItemControllers> {
  bool? withSection;
   StoreItem({
     this.withSection,
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: AppColors.whiteColor
        ), child: Material(
        child: SafeArea(child:Container(
          decoration:  BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.background2),
                fit: BoxFit.cover,
              )
          ),
          child: Obx(() {
            switch (controller.pageState.value) {
              case 1:
                {
                  return previewPage();
                }
              case 2:
                {
                  return errorPage();
                }
              default:
                return Container(width: Get.width, height: Get.height, color: Theme
                    .of(Get.context!)
                    .colorScheme
                    .background,);
            }
          }),
        ))));
  }



  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }

  Widget previewPage () {
    return  controller.pageState.value==1 &&controller.pageStateProduct.value==0 ? Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: Padding(
        padding:  EdgeInsets.only(right: Get.height*0.015,left:   Get.height*0.015,top: Get.height*0.01),
        child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.black),onPressed: (){Get.back();},),
      )),
      body: loadingPage(),
    ):

      AnimationLimiter(
        child: Stack(
          alignment: alSettings.rTL.value?  Alignment.topRight: Alignment.topLeft,
          children: [
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AnimationConfiguration.staggeredList(
                position: 0,
                delay: const Duration(milliseconds: 100),
                child: SlideAnimation(
                    duration: const Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 2500),
                      child:CustomCarouselSlider(
                        items:controller.itemStore.value.itemImages!.map((e) =>  CarouselItem(
                          image:  ExtendedImage.network(
                              e.imageUrl.toString(),
                              headers: ALMethode.getApiHeader(),
                              fit: BoxFit.cover,
                              cache: true,
                              handleLoadingProgress: true,
                              timeRetry: const Duration(seconds: 1),
                              printError: true,
                              timeLimit  :const Duration(seconds: 1),
                              borderRadius: BorderRadius.circular(0),
                              loadStateChanged: (ExtendedImageState state) {
                                switch (state.extendedImageLoadState) {
                                  case LoadState.failed:
                                    return GestureDetector(
                                      key: UniqueKey(),
                                      onTap: () {
                                        state.reLoadImage();
                                      },
                                      child: Container(
                                        width: Get.width,
                                        height: Get.height*0.45,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child:const Icon(CupertinoIcons.refresh_circled_solid,size: 40,color: AppColors.basicColor,semanticLabel: 'failed',),
                                      ),
                                    );
                                  case LoadState.loading:
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: Get.width,
                                          height: Get.height*0.45 ,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        Container(child:
                                        Platform.isAndroid? const CircularProgressIndicator(color: AppColors.grayColor,strokeWidth: 1,backgroundColor: AppColors.whiteColor,) :  CupertinoActivityIndicator(color: Theme.of(Get.context!).primaryColorDark,radius: 15),
                                        )
                                      ],
                                    );
                                  case LoadState.completed:
                                  // TODO: Handle this case.
                                    break;
                                }
                                return null;
                              }
                            //cancelToken: cancellationToken,
                          ),
                          boxDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.bottomCenter,
                              end: FractionalOffset.topCenter,
                              colors: [
                                Colors.blueAccent.withOpacity(1),
                                Colors.black.withOpacity(.3),
                              ],
                              stops: const [0.0, 1.0],
                            ),
                          ),
                          onImageTap: (i) {},
                        )).toList(),
                        height: Get.height*0.45,
                        subHeight: 50,
                        // borderRadius: 0,
                        width: Get.width*0.85,
                        autoplay: false,
                        showSubBackground: false,
                        showText: false,

                        unselectedDotColor: AppColors.secondaryColor,

                        selectedDotColor: AppColors.basicColor,
                      )))),
                SizedBox(height: Get.height*0.01,),
                AnimationConfiguration.staggeredList(
                    position:1,
                    delay: const Duration(milliseconds: 150),
                    child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(milliseconds: 2500),
                            child:Padding(
                              padding:  EdgeInsets.only(right:  Get.height*0.03,left:  Get.height*0.03,top: Get.height*0.01),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(child: Text(controller.product.itemName.toString(),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w800),)),

                                  Text(ALMethode.formatNumberWithSeparators('${controller.itemStore.value.itemPrice} ${alSettings.currency}'),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w800,color: AppColors.basicColor),),
                                ],
                              ),
                            )

                        ))),
                SizedBox(height: Get.height*0.01,),
                AnimationConfiguration.staggeredList(
                    position:1,
                    delay: const Duration(milliseconds: 200),
                    child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(milliseconds: 2500),
                            child:Padding(
                              padding:  EdgeInsets.only(right:  Get.height*0.03,left:  Get.height*0.03,top: Get.height*0.01),
                              child:Container(
                                width: Get.width,
                                height: Get.height*0.33,
                                child: ListView(
                                  children: [
                                    Text(textAlign: TextAlign.start,textDirection:  alSettings.rTL.value? ui.TextDirection.ltr:TextDirection.rtl,controller.itemStore.value.itemDescription
                                        .toString(),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,height: 1.3),)
                                  ],
                                ),
                              ),
                            )

                        ))),

              ],
            ),
            Padding(
            padding:  EdgeInsets.only(right:8,left:  8,top: Get.height*0.01),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.black),onPressed: (){Get.back();},),
            ),
            AnimationConfiguration.staggeredList(
                position:4,
                delay: const Duration(milliseconds: 150),
                child: SlideAnimation(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 2500),
                        child:Padding(
                            padding:  EdgeInsets.only(right:  Get.height*0.03,left:  Get.height*0.03,top: Get.height*0.01),
                            child:Align(alignment: Alignment.bottomCenter,child: Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                width: Get.width*0.9,
                                child: ALConstantsWidget.elevatedButton(onPressed: (){
                                  ALConstantsWidget.awesomeDialog(
                                      child: SingleChildScrollView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0,right: 8),
                                          child: StatefulBuilder(
                                              builder: (context, setState) {
                                                String price='';
                                                setState((){
                                                  price =(int.parse(controller.controller.text)*int.parse(controller.itemStore.value.itemPrice.toString())).toString();

                                                });
                                                return  Column(
                                            children: [
                                              Text(TranslationKeys.addToCard.tr,style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.w800),),
                                              SizedBox(height: Get.height*0.05,),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                Expanded(child: Text(TranslationKeys.quantity.tr,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 19),)),

                                                Container(width: Get.width*0.35,height: Get.height*0.04,child: CustomTextInput(onTap: (){
                                                  setState((){
                                                    price =(int.parse(controller.controller.text)*int.parse(controller.itemStore.value.itemPrice.toString())).toString();
                                                  });
                                                },controller: controller.controller),)
                                              ]),
                                              SizedBox(height: Get.height*0.03,),
                                              Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Expanded(child: Text(TranslationKeys.price.tr,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 19),)),
                                                          Text(ALMethode.formatNumberWithSeparators('$price ${alSettings.currency}'),style: const TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: AppColors.basicColor),),
                                                        ]),
                                              SizedBox(height: Get.height*0.03,)]);}))),
                                      title: TranslationKeys.addToCard.tr,
                                      btnCancelText: TranslationKeys.cancel.tr,
                                      btnOkText: TranslationKeys.add.tr,
                                      controller: controller.btnController,
                                      onPressed: ()async{
                                        controller.addToCart();
                                      });

                                }, text: TranslationKeys.addToCard.tr)
                            ),)))))
          ],
        ),
    );

  }

  Widget errorPage () {
    return ALConstantsWidget.errorServer(callBack: (){
      controller.onInit();
    });
  }

}