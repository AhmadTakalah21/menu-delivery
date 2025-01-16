
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:animated_switch/animated_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALWidget/ALProduct.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Search/Controllers/SearchControllers.dart';

import '../../../../Services/Translations/TranslationKeys/TranslationKeys.dart';

class Search extends StatefulWidget {
  RxList<Category> category =<Category>[].obs;

   Search({
     required this.category,
     super.key
   });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  SearchControllers controller = Get.put(SearchControllers());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.category=widget.category;
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(systemNavigationBarColor: Color(0xfff8f8f8),statusBarIconBrightness: Brightness.light, systemNavigationBarIconBrightness: Brightness.light, systemNavigationBarDividerColor: AppColors.basicColor), child: Material(color: Colors.transparent,
        child: SafeArea(child:Obx(() {
          switch (controller.pageState.value)
          {
            case 1:
              {
                return previewPage();
              }
            case 2:
              {
                return errorPage();
              }
            default:
              return  SizedBox(width: Get.width,height: Get.height,);
          }}),)));
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
                            Text(TranslationKeys.search.tr,style: const TextStyle(fontSize: 21,fontWeight: FontWeight.w700),),
                          ],
                        ),

                      ],
                    )
                  ],
                ),


                if(controller.pageStateProduct.value!=0)
                  Column(
                    children: [
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
                                child:GetBuilder<SearchControllers>(init: controller,builder: (set)=>ValueListenableBuilder<TextDirection>(
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
                                        hintText:TranslationKeys.search.tr,
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

                      SizedBox(height: Get.height*0.03,),

                      Row(children: [

                        Expanded(child: Text(TranslationKeys.filters.tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)),

                        const SizedBox(width: 5,),

                        Container(
                          width: Get.width*0.40,
                          height: Get.height*0.08,
                          child: GetBuilder<SearchControllers>(init: controller,builder: (state)=>controller.category.isEmpty?const SizedBox():
                          CustomDropdown<String>.search(
                            maxlines: 5,



                            decoration: CustomDropdownDecoration(

                                closedFillColor: const Color(0xFFF2F2F2),
                                closedBorderRadius: BorderRadius.circular(100),
                                listItemStyle: TextStyle(fontSize: 13),
                                headerStyle: TextStyle(fontSize: 13),

                                closedBorder: Border.all(color: AppColors.basicColor,width: 0.5),


                                searchFieldDecoration: SearchFieldDecoration(

                                  suffixIcon: (onClear){
                                    return IconButton(splashRadius: 20,onPressed:  onClear, icon: const Icon(Icons.close,color: AppColors.secondaryColor,));
                                  },
                                  prefixIcon: const Icon(Icons.search,color: AppColors.secondaryColor,),
                                )
                            ),

                            noResultFoundText: TranslationKeys.notFound.tr,

                            closedHeaderPadding: EdgeInsets.only(top: Get.height*0.005,bottom: Get.height*0.005,right: Get.width*0.04,left: Get.width*0.04),
                            items: controller.categoryNameS,
                            excludeSelected: false,
                            hintText:controller.categoryName.value.tr,

                            onChanged: (value) {
                              if(value!=TranslationKeys.all.tr)
                                {
                                  controller.categoryId.value=controller.category.value.where((element) => element.name==value).first.id.toString();
                                }
                              else
                                {
                                  controller.categoryId.value='all';
                                }
                              controller.categoryName.value =value;
                              controller.update();
                            },
                          ),),
                        ),
                        const SizedBox(width: 10,),
                        Container(
                          alignment: Alignment.bottomLeft,child:  Align(alignment: Alignment.topLeft,child: AnimatedSwitch(
                          textOn: TranslationKeys.all.tr,
                          textOff : TranslationKeys.offers.tr,
                          iconOff: Icons.abc,
                          iconOn: Icons.abc,
                          width:  Get.width*0.35,
                          height:  Get.width/8,
                          colorOff: Colors.white,
                          colorOn: Colors.white,
                          indicatorColor:AppColors.basicColor,
                          textStyle: const TextStyle(color: Colors.black),
                          onSwipe: null,
                          onChanged: (bool status){
                            if(status!=controller.status.value)
                            {
                              controller.page =2;
                              controller.status.value=status;
                              controller.filterProduct();
                            }
                          },
                        ),),)
                      ],)
                    ],
                  ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
          Expanded(child:  Container(child:
          (controller.pageStateSearch.value==1 &&   !controller.pageSearchBool.value  &&   controller.productSearch.isEmpty && (controller.categoryId.value!='all' || controller.searchController.text.isNotEmpty )) || (controller.pageStateProduct.value==1 && controller.product.isEmpty) ?  ALConstantsWidget.NotFoundData(controller.pageStateSearch.value==1 &&   !controller.pageSearchBool.value  && controller.searchController.text.isNotEmpty  &&  controller.productSearch.isEmpty ? TranslationKeys.notFound.tr: TranslationKeys.notFoundData.tr):
          controller.pageStateSearch.value==0 ||  controller.pageStateProduct.value==0  ? loadingPage():
          Stack(
            children: [
            SmartRefresher(
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
                child:GetBuilder<SearchControllers>(init:controller,builder: (set)=>  AnimationLimiter(
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: Get.height*0.01),
                      shrinkWrap: true,
                      primary: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.productSearch.isNotEmpty ||controller.categoryId.value!='all'  ? controller.productSearch.length:  !controller.pageSearchBool.value && (controller.searchController.text.isNotEmpty ||controller.productSearch.isNotEmpty)? controller.productSearch.length : controller.product.length,
                      itemBuilder: (context,index){
                        dynamic item
                        = controller.productSearch.isNotEmpty ? controller.productSearch[index]:
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
                                    Get.toNamed(Routes.StoreItem,arguments: {'product':item});

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
