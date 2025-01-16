



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
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALWidget/ALProduct.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/CategoryDetails/Controllers/CategoryDetailsControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';

class CategoryDetails extends GetView<CategoryDetailsControllers> {
  const CategoryDetails({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness:Brightness.dark,
          // systemNavigationBarColor: AppColors.whiteColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Color(0xFFF7F7F7)
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
    return Padding(
      padding:  EdgeInsets.only(right: Get.width*0.04,left: Get.width*0.04,),
      child: Column(
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [

                            SizedBox(
                              width: Get.width*0.06,
                                child: IconButton(padding: EdgeInsets.zero,splashRadius: 12,icon: const Icon(Icons.arrow_back_ios,size: 18,color: Colors.black),onPressed: (){Get.back();},)),
                            Text(TranslationKeys.appName.tr,style: const TextStyle(color: AppColors.basicColor,fontSize: 21,fontWeight: FontWeight.w800),),



                          ],
                        ),
                        SizedBox(height: Get.height*0.015,),
                        Text(controller.category.name.toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700,),),
                        SizedBox(height: Get.height*0.015,),

                      ],
                    )
                  ],
                ),


                if(controller.pageStateProduct.value!=0)
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(CupertinoIcons.search,size: 20),
                        const SizedBox(width: 1,),
                        Text(TranslationKeys.search.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),

                      ],
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: SizedBox(
                        height: Get.height*0.05,
                        child:GetBuilder<CategoryDetailsControllers>(init: controller,builder: (set)=>ValueListenableBuilder<TextDirection>(
                          valueListenable: controller.textDir,
                          child: const SizedBox(),
                          builder: (context, valueTextDirection, child) => TextFormField(
                          focusNode: controller.focusNode,
                          controller:  controller.searchController,
                          style: const TextStyle(textBaseline: TextBaseline.alphabetic),
                          cursorColor: AppColors.basicColor,
                          decoration:  InputDecoration(
                            prefixIcon: controller.isClear.value?IconButton(
                                splashRadius: 0.1,
                                onPressed: (){
                                  controller.isClear.value=false;
                                  controller.searchController.clear();
                                  controller.productSearch.clear();
                                  controller.pageSearchBool.value=false;

                                }, icon: const Icon(Icons.clear,color: AppColors.secondaryColor)):null,
                            contentPadding:  const EdgeInsets.only(top: 0,left: 15,right: 15),
                            hintText:TranslationKeys.productSearch.tr,
                            focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 0.7,color:AppColors.basicColor)),
                            enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 0.5,color: AppColors.basicColor)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: const BorderSide(width: 5,color: AppColors.basicColor)),
                            hintMaxLines: 1,
                            fillColor: const Color(0xFFF2F2F2),
                            filled: true,
                            hintStyle: const TextStyle(fontSize: 14),

                          ),
                          readOnly: controller.pageStateSearch.value==0 || controller.pageStateProduct.value==0 ,
                          onFieldSubmitted: (value) {
                            if(value.isNotEmpty )
                            {
                              controller.pageSearchBool.value=true;
                              controller.isClear.value=true;
                              controller.filterProduct();
                              controller.showSearch.value=false;
                            }
                            else
                            {
                              controller.isClear.value=false;
                              controller.productSearch.clear();
                              controller.pageSearchBool.value=false;
                              controller.showSearch.value=true;
                            }
                          },
                          onChanged: (value) {
                            final dir = ALMethode.getDirection(value.trim());
                            if (dir != valueTextDirection)
                            {
                              controller.textDir.value = dir;
                              controller.update();
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
                              controller.productSearch.clear();
                            }
                          },

                        )),
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Text(TranslationKeys.product.tr,style: const TextStyle(fontSize: 21,fontWeight: FontWeight.w700),)
                  ],
                ),
              ],
            ),
          ),
          Expanded(child:  Container(child:
          (controller.pageStateSearch.value==1 &&   !controller.pageSearchBool.value  && controller.searchController.text.isNotEmpty  &&  controller.productSearch.isEmpty) || (controller.pageStateProduct.value==1 && controller.product.isEmpty)? ALConstantsWidget.NotFoundData(controller.pageStateSearch.value==1 &&   !controller.pageSearchBool.value  && controller.searchController.text.isNotEmpty  &&  controller.productSearch.isEmpty ? TranslationKeys.notFound.tr: TranslationKeys.notFoundData.tr):
          controller.pageStateSearch.value==0 ||  controller.pageStateProduct.value==0  ? loadingPage():
          Stack(
            children: [
            GetX<CategoryDetailsControllers>(init:controller,builder: (set)=> SmartRefresher(
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
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.productSearch.isNotEmpty ? controller.productSearch.length:  !controller.pageSearchBool.value && (controller.searchController.text.isNotEmpty ||controller.productSearch.isNotEmpty)? controller.productSearch.length : controller.product.length,
                      itemBuilder: (context,index){
                        dynamic item = controller.productSearch.isNotEmpty ? controller.productSearch[index]:
                        !controller.pageSearchBool.value && (controller.searchController.text.isNotEmpty ||controller.productSearch.isNotEmpty)?controller.productSearch[index]: controller.product[index];
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
                                      child: ALProduct(
                                        key: UniqueKey(),
                                        product:item,
                                      ),onTap:()async{
                                       Get.toNamed(Routes.StoreItem,arguments:{'product':item});

                                  }),)));
                      }),),
              )),
            ],
          )),)
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