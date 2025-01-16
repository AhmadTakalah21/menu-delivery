








import 'dart:io';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALWidget/CustomTextInput.dart';
import 'package:shopping_land_delivery/ALWidget/SLItem.dart';
import 'package:shopping_land_delivery/ALWidget/SLWidgetText.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/BrandsDetails/Controllers/BrandsDetailsControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrandsDetails extends GetView<BrandsDetailsControllers> {
  bool? withSection;
  BrandsDetails({
    this.withSection,
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: AppColors.basicColor,
            statusBarColor: AppColors.whiteColor,
            systemNavigationBarDividerColor: AppColors.basicColor
        ), child: Material(
        child:Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: Padding(
              padding:  EdgeInsets.only(right: Get.height*0.015,left:   Get.height*0.015,top: Get.height*0.01),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.black),onPressed: (){Get.back();},),
            )),
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
        }))));
  }




  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }

  Widget previewPage () {
    return Padding(
      padding:  EdgeInsets.only(right: Get.width*0.04,left: Get.width*0.04,),
      child: Column(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),

            child: Column(
              children: [

                SizedBox(
                  height: Get.height*0.05,
                  child:GetBuilder<BrandsDetailsControllers>(init: controller,builder: (set)=>ValueListenableBuilder<TextDirection>(
                      valueListenable: controller.textDir,
                      child: const SizedBox(),
                      builder: (context, valueTextDirection, child) => TextFormField(
                        focusNode: controller.focusNode,
                        controller:  controller.searchController,
                        style: const TextStyle(textBaseline: TextBaseline.alphabetic),
                        cursorColor: AppColors.basicColor,
                        decoration:  InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search,color: AppColors.grayColor,size: 18),
                          suffixIcon: controller.isClear.value?InkWell(
                              onTap: (){
                                controller.isClear.value=false;
                                controller.searchController.clear();
                                controller.optionWidgetSearch.clear();
                                controller.pageSearchBool.value=false;
                                controller.update();
                              }, child: const Icon(Icons.clear,color: AppColors.secondaryColor)):null,
                          contentPadding:  const EdgeInsets.only(top: 0,left: 15,right: 15),
                          hintText:TranslationKeys.search.tr,
                          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 0.3,color:AppColors.grayColor)),
                          enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 0.2,color: AppColors.grayColor)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 0.2,color: AppColors.grayColor)),
                          hintMaxLines: 1,
                          fillColor: const Color(0xFFF2F2F2),
                          filled: true,
                          hintStyle: const TextStyle(fontSize: 14),
                        ),
                        readOnly: controller.pageStateSearch.value==0 || controller.isGetTypes.value ,
                        onFieldSubmitted: (value) {
                          if(value.isNotEmpty )
                          {
                            controller.pageSearchBool.value=true;
                            controller.isClear.value=true;
                            // controller.filterProduct();
                            controller.showSearch.value=false;

                          }
                          else
                          {
                            controller.isClear.value=false;
                            controller.optionWidgetSearch.clear();
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
                            controller.optionWidgetSearch.clear();
                          }
                          controller.update();
                        },

                      )),
                  ),
                ),


                Container(padding: EdgeInsets.only(top: 10),height: Get.height*0.06,width: Get.width,alignment: Alignment.center,child: Text(controller.brand.name.toString(),style: TextStyle(color: AppColors.grayColor,fontSize: 18,fontWeight: FontWeight.w600),)),


                if(!controller.isGetItems.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top:  1,bottom: 1),
                      height: Get.height*0.055,
                      width: Get.width,
                      child: AnimationLimiter(
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 2),
                              scrollDirection: Axis.horizontal,
                              physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                        duration: const Duration(milliseconds: 900),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        child: FadeInAnimation(
                                          child:  Padding(
                                              padding: EdgeInsets.only(right: index!=0? Get.width*0.02 : 0),
                                              child:    Container(
                                                width: Get.width*0.25,
                                                height: Get.height*0.75,
                                                child: Skeletonizer(
                                                    enabled: true,
                                                    child:Skeleton.unite(
                                                        borderRadius: BorderRadius.circular(100),
                                                        child : const Card(
                                                          color:Color(0xFFE8E8E8) ,
                                                          child: ListTile(
                                                            focusColor:Color(0xFFE8E8E8) ,
                                                          ),
                                                        )
                                                    )),
                                              )
                                          ),)));
                              })),
                    ),
                  ),

                if(controller.isGetItems.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top:  1,bottom: 1),
                      height: Get.height*0.045,
                      width: Get.width,
                      child: AnimationLimiter(
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 2),
                              scrollDirection: Axis.horizontal,
                              physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                              itemCount: controller.masterCategories.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item =controller.masterCategories.value[index];

                                return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                        duration: const Duration(milliseconds: 900),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        child: FadeInAnimation(
                                          child:  Padding(
                                              padding: EdgeInsets.only(right: index!=0? Get.width*0.02 : 0),
                                              child: InkWell(
                                                  borderRadius: BorderRadius.circular(100),
                                                  onTap: controller.pageStateProduct.value==0?null:(){
                                                    controller.masterId.value=item.id.toString();
                                                    controller.update();
                                                    controller.display_sub_categories();
                                                  },
                                                  child: GetBuilder<BrandsDetailsControllers>(init: controller,builder: (c)=> SLWidgetText(
                                                      title: item.name.toString(),
                                                      backGroundColor: AppColors.basicColor,
                                                      isActive: controller.masterId.value==item.id.toString(),
                                                      lightBorder: false),
                                                  ))
                                          ),)));
                              })),
                    ),
                  ),

                if(!controller.isGetSub.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top:  1,bottom: 1),
                      height: Get.height*0.055,
                      width: Get.width,
                      child: AnimationLimiter(
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 2),
                              scrollDirection: Axis.horizontal,
                              physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                        duration: const Duration(milliseconds: 900),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        child: FadeInAnimation(
                                          child:  Padding(
                                              padding: EdgeInsets.only(right: index!=0? Get.width*0.02 : 0),
                                              child:    Container(
                                                width: Get.width*0.25,
                                                height: Get.height*0.75,
                                                child: Skeletonizer(
                                                    enabled: true,
                                                    child:Skeleton.unite(
                                                        borderRadius: BorderRadius.circular(100),
                                                        child : const Card(
                                                          color:Color(0xFFE8E8E8) ,
                                                          child: ListTile(
                                                            focusColor:Color(0xFFE8E8E8) ,
                                                          ),
                                                        )
                                                    )),
                                              )
                                          ),)));
                              })),
                    ),
                  ),

                if(controller.isGetSub.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top:  1,bottom: 1),
                      height: Get.height*0.045,
                      width: Get.width,
                      child: AnimationLimiter(
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 2),
                              scrollDirection: Axis.horizontal,
                              physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                              itemCount: controller.subCategories.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item =controller.subCategories.value[index];

                                return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 500),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                        duration: const Duration(milliseconds: 900),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        child: FadeInAnimation(
                                          child:  Padding(
                                              padding: EdgeInsets.only(right: index!=0? Get.width*0.02 : 0),
                                              child: InkWell(
                                                  borderRadius: BorderRadius.circular(100),
                                                  onTap: controller.pageStateProduct.value==0?null:(){
                                                    controller.subId.value=item.id.toString();
                                                    controller.update();
                                                    controller.display_items();
                                                  },
                                                  child: GetBuilder<BrandsDetailsControllers>(init: controller,builder: (c)=> SLWidgetText(
                                                      title: item.name.toString(),
                                                      backGroundColor: AppColors.secondaryColor,
                                                      isActive: controller.subId.value==item.id.toString(),
                                                      lightBorder: true),
                                                  ))
                                          ),)));
                              })),
                    ),
                  ),
                if(controller.isGetSub.value && controller.subCategories.isNotEmpty)
                const SizedBox(height: 10,),

                if(!controller.isGetTypes.value)
                  Container(
                    height: Get.height*0.576,
                    child: AnimationLimiter(

                      child: GridView.builder(
                          physics:const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.only(bottom: Get.height*0.01),
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {

                            return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                child: ScaleAnimation(
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                      child:  Padding(
                                          padding: EdgeInsets.only(bottom: Get.width*0.05),
                                          child:  Container(
                                            width: Get.width*0.25,
                                            height: Get.height*0.75,
                                            child: Skeletonizer(
                                                enabled: true,
                                                child:Skeleton.unite(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child : const Card(
                                                      color:Color(0xFFE8E8E8) ,
                                                      child: ListTile(
                                                        focusColor:Color(0xFFE8E8E8) ,
                                                      ),
                                                    )
                                                )),
                                          )
                                      ),)));
                          }),),
                  ),



                if(!controller.isGetTypes.value)
                  SizedBox(height: Get.height*0.01,),




              ],
            ),
          ),

          if(controller.isGetTypes.value)
            if(controller.isGetSub.value && controller.subCategories.isNotEmpty)
              SizedBox(height: Get.height*0.01,)
            else
              SizedBox(height: Get.height*0.000,),
          if(controller.isGetTypes.value)
            Expanded(child:  Container(child:
            controller.pageStateProduct.value==1 && (controller.masterCategories.isEmpty || ( controller.optionWidgetSearch.isEmpty && controller.searchController.text.trim().isNotEmpty))? ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
            controller.pageStateProduct.value==0  ? loadingPage():
            Stack(
              children: [
                GetX<BrandsDetailsControllers>(init:controller,builder: (set)=>Container(
                  child: SmartRefresher(
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
                    child: AnimationLimiter(
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: Get.height*0.01),
                          shrinkWrap: true,
                          primary: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.45,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5
                          ),
                          itemCount: controller.optionWidgetSearch.isNotEmpty  ? controller.optionWidgetSearch.length:  !controller.pageSearchBool.value && (controller.searchController.text.isNotEmpty ||controller.optionWidgetSearch.isNotEmpty)? controller.optionWidgetSearch.length : controller.optionWidget.length,
                          itemBuilder: (BuildContext context, int index) {
                            dynamic item = controller.optionWidgetSearch.isNotEmpty ? controller.optionWidgetSearch[index]: !controller.pageSearchBool.value && (controller.searchController.text.isNotEmpty ||controller.optionWidgetSearch.isNotEmpty)?controller.optionWidgetSearch[index]: controller.optionWidget[index];

                            return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                child: ScaleAnimation(
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                      child:  Padding(
                                          padding: EdgeInsets.only(bottom: Get.width*0.05),
                                          child: InkWell(
                                              onTap: (){
                                                FlutterStatusbarcolor.setNavigationBarColor(AppColors.whiteColor);
                                                FlutterStatusbarcolor.setStatusBarColor(AppColors.whiteColor);
                                                Get.toNamed(Routes.ItemsDetails,arguments:item )!.then((value) async {
                                                 await FlutterStatusbarcolor.setNavigationBarColor(AppColors.whiteColor);
                                                  FlutterStatusbarcolor.setStatusBarColor(AppColors.whiteColor);
                                                });
                                              },
                                              borderRadius: BorderRadius.circular(12),
                                              child: SLItem(
                                                  controller: controller,
                                                  item: item,
                                                  onLike: (Items item){
                                                    item.isFav!.value=item.isFav!.value==0?1:0;
                                                    controller.add_item_or_cancel_favourite(item);
                                                  }
                                              ))
                                      ),)));
                          }),),
                  ),
                )),

              ],
            )),),
        ],
      ),
    ) ;
  }

  Widget errorPage () {
    return ALConstantsWidget.errorServer(callBack: (){
      controller.onInit();
    });
  }

}