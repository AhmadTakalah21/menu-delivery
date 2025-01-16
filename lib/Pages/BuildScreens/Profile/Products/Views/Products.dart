










import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/ALWidget/ALPercents.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Products/Controllers/ProductsControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';

class Products extends GetView<ProductsControllers> {
  bool? withSection;

  Products({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: AppColors.whiteColor
        ), child: Material(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.background2),
                  fit: BoxFit.cover,
                )
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  leadingWidth: Get.width*0.1,
                  titleSpacing: Get.width*0.001,
                  title: Text(TranslationKeys.appName.tr,style: const TextStyle(color: AppColors.basicColor,fontSize: 21,fontWeight: FontWeight.w800),),
                  backgroundColor: Colors.transparent,elevation: 0,leading: Padding(
                padding:  EdgeInsets.only(right: Get.height*0.015,left:   Get.height*0.015,top: Get.height*0.00),
                child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 18),onPressed: (){Get.back();},),
              )),
              body:Obx(() {
                switch (controller.pageState.value) {
                  case 0:
                    {
                      return loadingPage();
                    }
                  case 1:
                    {
                      return previewPage();
                    }
                  case 2:
                    {
                      return errorPage();
                    }
                  default:
                    return Container(width: Get.width,height: Get.height,color: Theme.of(Get.context!).colorScheme.background,);
                }}),
            ))));
  }
  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }

  Widget previewPage () {
    return   AnimationLimiter(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                  padding:  EdgeInsets.only(right: Get.width*0.05,left:Get.width*0.05,),
                  child: Text(TranslationKeys.products.tr,style: const TextStyle(fontSize: 21,fontWeight: FontWeight.w800),)
              ),
              if(controller.percents.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16),
                child: SizedBox(
                  height: Get.height*0.05,
                  child: ValueListenableBuilder<TextDirection>(
                    valueListenable: controller.textDir,
                    child: const SizedBox(),
                    builder: (context, valueTextDirection, child) =>TextFormField(
                      focusNode: controller.focusNode,
                      controller:  controller.searchController,
                      style: TextStyle(textBaseline: TextBaseline.alphabetic),
                      cursorColor: AppColors.basicColor,
                      decoration:  InputDecoration(
                        prefixIcon: controller.isClear.value?IconButton(
                            splashRadius: 0.1,
                            onPressed: (){
                              controller.isClear.value=false;
                              controller.searchController.clear();
                              controller.percentsSearch.clear();
                              controller.pageSearchBool.value=false;
                
                            }, icon: const Icon(Icons.clear,color: AppColors.secondaryColor)):null,
                        contentPadding:  const EdgeInsets.only(top: 0,left: 15,right: 15),
                        hintText:TranslationKeys.search.tr,
                        focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 0.7,color:AppColors.basicColor)),
                        enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 0.5,color: AppColors.basicColor)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 5,color: AppColors.basicColor)),
                        hintMaxLines: 1,
                        fillColor: const Color(0xFFF2F2F2),
                        filled: true,
                        hintStyle: const TextStyle(fontSize: 14),
                
                      ),
                      onFieldSubmitted: (value) {
                        if(value.isNotEmpty )
                        {
                          controller.pageSearchBool.value=true;
                          controller.isClear.value=true;
                          controller.filterPercents();
                          controller.showSearch.value=false;
                        }
                        else
                        {
                          controller.isClear.value=false;
                          controller.percentsSearch.clear();
                          controller.pageSearchBool.value=false;
                          controller.showSearch.value=true;
                        }
                      },
                      onChanged: (value) {
                        final dir = ALMethode.getDirection(value.trim());
                        if (dir != valueTextDirection)
                        {
                          controller.textDir.value = dir;
                        }
                        if(value.isNotEmpty)
                        {
                          controller.isClear.value=true;
                          controller.pageSearchBool.value=true;
                        }
                        else
                        {
                          controller.isClear.value=false;
                          controller.pageSearchBool.value=false;
                          controller.percentsSearch.clear();
                        }
                      },
                
                    ),
                  ),
                ),
              ),
              Container(height: Get.height/1.46,margin: const EdgeInsets.only(top: 0),child:
            (controller.pageState.value==1 && controller.percents.isEmpty)? ALConstantsWidget.NotFoundData(controller.percents.isEmpty?TranslationKeys.notFoundData.tr:TranslationKeys.notFound.tr):
              controller.pageStateSearch.value==0  ? loadingPage():
              Padding(
                padding: const EdgeInsets.only(right: 14,left: 14),
                child: AnimationLimiter(
                  child:  SmartRefresher(
                      primary: true,
                      enablePullDown:true,
                      enablePullUp: true ,
                      header: WaterDropHeader(waterDropColor: AppColors.secondaryColor,refresh: ALConstantsWidget.loading(width:Get.width*0.1,height: Get.width*0.1,color: AppColors.basicColor), complete:ALConstantsWidget.smartRefresh() ),
                      footer: CustomFooter(
                        builder: (BuildContext context,LoadStatus? mode){
                          Widget body ;
                          if(mode==LoadStatus.idle){
                            body =   Text(TranslationKeys.moreProduct.tr);
                          }
                          else if(mode==LoadStatus.loading){
                            body = Platform.isAndroid? const CircularProgressIndicator(color: Colors.white,strokeWidth: 1,backgroundColor: AppColors.secondaryColor,) :  CupertinoActivityIndicator(color: Theme.of(Get.context!).primaryColorDark);
                          }
                          else if(mode == LoadStatus.failed){
                            body = const Text('');
                          }
                          else if(mode == LoadStatus.canLoading){
                            body =  Text(TranslationKeys.moreProduct.tr);
                          }
                          else{
                            body =  Text(TranslationKeys.noMore.tr);
                          }
                          return DefaultTextStyle(
                            style: const TextStyle(fontSize: 14, color:Colors.white),
                            child: Padding(padding:  EdgeInsets.only(left:  Get.width*0.27,right:  Get.width*0.27,) ,child:SizedBox(
                              height: mode==LoadStatus.loading ? 55 :Get.height*0.04,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    height: mode==LoadStatus.loading ? 55 :Get.height*0.045,
                                    decoration: BoxDecoration(
                                        color: mode==LoadStatus.loading ? Colors.transparent :AppColors.secondaryColor,
                                        borderRadius: BorderRadius.circular(18)),
                                    child: Center(child:body),
                                  ),
                                ],
                              ),
                            )),
                          );
                        },
                      ),
                      controller: controller.refreshController,
                      onRefresh: controller.getListOfRefresh,
                      onLoading: controller.getListOfLoading,
                      child:GetX<ProductsControllers>(init:controller,builder: (set)=>AnimationLimiter(
                        child:ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: Get.height*0.01),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: controller.percentsSearch.isNotEmpty ? controller.percentsSearch.length:  !controller.pageSearchBool.value && (controller.searchController.text.isNotEmpty ||controller.percentsSearch.isNotEmpty)? controller.percentsSearch.length : controller.percents.length,
                      itemBuilder: (context,index){
                        dynamic item = controller.percentsSearch.isNotEmpty ? controller.percentsSearch[index]:
                        !controller.pageSearchBool.value && (controller.searchController.text.isNotEmpty ||controller.percentsSearch.isNotEmpty)?controller.percentsSearch[index]: controller.percents[index];
                        return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            columnCount: 2,
                            child: ScaleAnimation(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: FadeInAnimation(
                                  child:  InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      child: ALPercents(
                                        key: UniqueKey(),
                                        percents: item,
                                        onChanged: (int price){
                                          controller.onChanged(price:price,percents:item);
                                        },
                                      ),))));
                      })))),),
              )),
              if(controller.percents.isNotEmpty)
              ALConstantsWidget.elevatedButtonAnimation(
                  onPressed: (){
                    controller.add_percents();
                  },
                  text: TranslationKeys.edit,
                  controller: controller.btnController)


            ],
          ),

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




