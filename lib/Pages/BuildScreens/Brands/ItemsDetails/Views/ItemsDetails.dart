








import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALWidget/CustomTextInput.dart';
import 'package:shopping_land_delivery/ALWidget/SLWidgetText.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/ItemsDetails/Controllers/ItemsDetailsControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class ItemsDetails extends GetView<ItemsDetailsControllers> {
  bool? withSection;
  ItemsDetails({
    this.withSection,
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value:  SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: controller.color??Colors.white,
            systemNavigationBarDividerColor: controller.color?? AppColors.whiteColor
        ), child: Material(
        child:GetX<ItemsDetailsControllers>(init: controller,builder: (s)=>Scaffold(
            appBar: controller.isGetTypes.value?null:AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: Padding(
              padding:  EdgeInsets.only(right: Get.height*0.015,left:   Get.height*0.015,top: Get.height*0.01),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.black),onPressed: (){Get.back();},),
            )),
            bottomNavigationBar: !controller.isGetTypes.value?null: Container(
              padding: EdgeInsets.only(left: Get.width*0.01, right: Get.width*0.04,bottom:Get.width*0.02),
              width: Get.width*0.5,
              child: Row(
                children: [
                  Container(
                    height: Get.height*0.06,
                    width: Get.width*0.78,
                    child:  ALConstantsWidget.elevatedButtonWithStyle(
                        text: TranslationKeys.addToCard.tr,
                        colors: AppColors.basicColor,
                        textColor: AppColors.whiteColor,
                        onTap: (){
                          controller.add_item_to_cart();

                        }
                    ),
                  ),
                  SizedBox(width: Get.width*0.02),
                  Container(
                      padding: EdgeInsets.all(Get.width*0.03),
                      decoration: BoxDecoration(
                    border: Border.all(color: AppColors.basicColor,width: 0.5),
                    borderRadius: BorderRadius.circular(15)
                  ),child: Icon(CupertinoIcons.cart,color:  AppColors.basicColor,)),
                ],
              ),
            ),
            body: Obx(() {
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
        })))));
  }




  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }
  Widget previewPage () {
    return ListView(children: [
        if(!controller.isGetTypes.value)
      Center(child: Container(height: Get.height,child: loadingPage())),
        if(controller.isGetTypes.value)
          Stack(
            children: [
              CustomCarouselSlider(


                items:controller.item.isEmpty?[]: controller.item.first.images!.map((e) => CarouselItem(
                  image:  ExtendedImage.network(
                      e.url.toString().replaceAll('\\', ''),
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
                                height: Get.height*0.20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(0),
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
                                  height: Get.height*0.20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                Container(child:
                                Platform.isAndroid? const CircularProgressIndicator(color: AppColors.grayColor,strokeWidth: 1,backgroundColor: AppColors.whiteColor,) :  CupertinoActivityIndicator(radius: 15),
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

                )).toList(),
                height: Get.height*0.5,
                //borderRadius: 0,
                dotSpacing: 1,
                width: Get.width,
                autoplay: true,

                showSubBackground: false,
                showText: false,
                selectedDotWidth: 6,
                unselectedDotWidth: 4.5,
                selectedDotHeight: 6,
                unselectedDotHeight: 4.5,
                unselectedDotColor: AppColors.grayColor,
                selectedDotColor: AppColors.basicColor,
              ),
              Padding(
                padding:  EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(right: Get.height*0.015,left:   Get.height*0.015,top: Get.height*0.01),
                      child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.black),onPressed: (){Get.back();},),
                    ),
                    GetBuilder<ItemsDetailsControllers>(init: controller,builder: (builder)=>Container(

                      width: Get.height*0.07,
                      height: Get.height*0.07,
                      margin: EdgeInsets.only(bottom: Get.height*0.00),
                      child: LikeButton(
                        size: 30,
                         onTap: (value) async {
                               await
                          Future.delayed(Duration(seconds: 1),(){
                            controller.item.first.isFavChange=true;
                            controller.item.first.isFav!.value=controller.item.first.isFav!.value==0?1:0;
                            controller.add_item_or_cancel_favourite(controller.item.first.id.toString());
                          });
                               return true;
                        } ,

                        isLiked: controller.item.first.isFavChange? null :controller.item.first.isFav!.value==1?true:false,
                        likeCount: controller.item.first.countFavourites,
                        circleColor:
                        CircleColor(start:  AppColors.readColor, end:  AppColors.readColor),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor:  AppColors.readColor,
                          dotSecondaryColor: AppColors.readColor,
                        ),

                        likeBuilder: (bool isLiked) {
                          return Icon(
                            isLiked ? CupertinoIcons.heart_fill :CupertinoIcons.heart,
                            color: isLiked ? AppColors.readColor : Colors.grey,
                            size: 30,
                          );
                        },
                      ),
                    ))




                  ],
                ),
              )
            ],
          ),
      if(controller.isGetTypes.value)
        Container(
          padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02,bottom:Get.width*0.02,top: Get.width*0.02),

          decoration: BoxDecoration(
              // color: Color(0xffF5F5F5),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width*0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(controller.item.first.name.toString(),textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.black)),
                    SizedBox(height: 5,),
                    Text(controller.item.first.brandName.toString(),textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: Colors.black),),
                    SizedBox(height: 5,),
                    Text(controller.item.first.description.toString(),textAlign: TextAlign.start,maxLines: 10,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: AppColors.grayColor),),

                  ],
                ),
              ),
              SizedBox(height: 3,),
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(controller.item.first.priceAfterOffer!=null && controller.item.first.priceAfterOffer!>0)
                      Text(ALMethode.formatNumberWithSeparators(controller.item.first.priceAfterOffer.toString()+alSettings.currency),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,decoration: TextDecoration.lineThrough,color: AppColors.grayColor),),
                      Text(ALMethode.formatNumberWithSeparators(controller.item.first.price.toString()+alSettings.currency),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: AppColors.secondaryColor),),
                    SizedBox(height: Get.height*0.02,),
                    CustomTextInput(
                        onTap: (){},
                        controller: controller.quantityTextE)
                  ],),
              ),


            ],
          ),

        ),
      if(controller.isGetTypes.value)
        Stack(
            children: [
              SingleChildScrollView(


                child: Column(
                  children: [
                    ListView.builder(

                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.item.first.units!.length,
                        itemBuilder:  (c,index) {
                          final parent =controller.item.first.units![index];
                          return
                            Padding(
                              padding: const EdgeInsets.only(right:5,left: 5),
                              child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:10,left: 10),
                                        child: Text(parent.name.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800)),
                                      ),
                                      Container(
                                        height: Get.height*0.045,
                                        width: Get.width,
                                        child: AnimationLimiter(
                                            child: ListView.builder(itemCount: parent.measurements!.length,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (c,indexItem){
                                                  var item =parent.measurements![indexItem];
                                                  return Padding(
                                                    padding:  EdgeInsets.only(right: indexItem!=0?Get.width*0.02:0),
                                                    child: AnimationConfiguration.staggeredGrid(
                                                        position: indexItem,
                                                        duration: const Duration(milliseconds: 500),
                                                        columnCount: 2,
                                                        child: ScaleAnimation(
                                                            duration: const Duration(milliseconds: 900),
                                                            curve: Curves.fastLinearToSlowEaseIn,
                                                            child: FadeInAnimation(child:
                                                            Padding(
                                                              padding: const EdgeInsets.only( top: 2.0),
                                                              child: InkWell(
                                                                borderRadius: BorderRadius.circular(100),
                                                                onTap: (){
                                                                  if(controller.measurements.isEmpty)
                                                                    {
                                                                      controller.measurements.add(item);
                                                                    }
                                                                  else
                                                                    {
                                                                      controller.measurements.removeWhere((element) => element.unitName.toString()==item.unitName.toString());
                                                                      controller.measurements.add(item);

                                                                    }
                                                                  controller.update();

                                                                },
                                                                child: GetBuilder<ItemsDetailsControllers>(init: controller,builder: (c)=> SLWidgetText(
                                                                    title: item.name.toString(),
                                                                    backGroundColor: AppColors.basicColor,
                                                                    isActive: controller.measurements.any((element) => element.id.toString()==item.id.toString()),
                                                                    lightBorder: false)),
                                                              ),
                                                            )))),
                                                  );
                                                })


                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            )

                          ;
                        }),
                  ],
                ),
              )]),

    ],);
  }

  Widget errorPage () {
    return ALConstantsWidget.errorServer(callBack: (){
      controller.onInit();
    });
  }

}