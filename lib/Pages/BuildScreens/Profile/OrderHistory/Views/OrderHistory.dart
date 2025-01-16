









import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/src/datetime_picker_theme.dart' as picker_theme;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALWidget/ALOrderHistory.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Controllers/OrderHistoryControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';





class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {


  OrderHistoryControllers controller = Get.put(OrderHistoryControllers());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,

        ), child: Material(
        color:  Colors.white,
        child: Container(
            decoration: BoxDecoration(
            ),
            child:Scaffold(
              extendBodyBehindAppBar: false,
              resizeToAvoidBottomInset: false,
              extendBody: false,
              backgroundColor: AppColors.secondaryColor5,
              appBar: AppBar(
                leadingWidth: Get.width * 0.2,
                titleSpacing: Get.width * 0.001,
                title: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    'الطلبات',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                actions: [
                  Obx(() {
                    return Switch(
                      value: controller.isActive.value,
                      onChanged: (value) async {
                        await controller.updateActiveStatus(value);
                      },
                      activeColor: AppColors.secondaryColor,
                    );
                  }),
                ],

                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
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
      child: Column(
        children: [
          Container(
            height: Get.height*0.23,
            child: Column(
              children: [

                Padding(
                  padding:  EdgeInsets.only(right: Get.width*0.1,top: 8,bottom: 8,left: Get.width*0.1),
                    child:TabBar(
                      onTap: (int index) {
                        controller.changedIndex(index: index);  // يتم تغيير الحالة بناءً على التبويب
                      },
                      isScrollable: false,
                      physics: const NeverScrollableScrollPhysics(),
                      indicatorPadding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.01,
                        vertical: Get.width * 0.025,
                      ),
                      controller: controller.tapController,
                      indicatorColor: AppColors.secondaryColor,
                      unselectedLabelColor: Colors.black,
                      labelColor: AppColors.secondaryColor,
                      indicatorWeight: 3,
                      labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      tabs: [
                        FittedBox(
                          child: Text(
                            TranslationKeys.pending.tr,  // قيد المعالجة
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            TranslationKeys.processing.tr,  // قيد التوصيل
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            TranslationKeys.delivered.tr,  // تم التوصيل
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    )
                ),


               Column(

                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                 Row(children: [




                 ],

                 ),
                 SizedBox(height: Get.height*0.02,),
                 Row(children: [
                   SizedBox(width: Get.height*0.01,),
                   SingleChildScrollView(
                     child: Container(
                       width: Get.width * 0.4,
                       height: Get.height * 0.065,
                       child: TextFormField(
                         onFieldSubmitted: (val) {
                           if (val.isNotEmpty) {
                             controller.filterProduct();
                           }
                         },
                         controller: controller.searchController,
                         keyboardType: TextInputType.number,
                         inputFormatters: [
                           FilteringTextInputFormatter.deny(RegExp(r'[-,]')),
                         ],
                         cursorColor: AppColors.secondaryColor,
                         decoration: InputDecoration(
                           prefixIcon: Icon(Icons.search),
                           contentPadding: const EdgeInsets.only(right: 10, left: 10),
                           focusedErrorBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(100),
                             borderSide: const BorderSide(width: .8, color: AppColors.grayColor),
                           ),
                           errorBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(100),
                             borderSide: BorderSide(width: .8, color: Colors.redAccent.shade100),
                           ),
                           disabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(100),
                             borderSide: const BorderSide(width: .4, color: AppColors.grayColor),
                           ),
                           focusedBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(100),
                             borderSide: const BorderSide(width: .8, color: AppColors.grayColor),
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(100),
                             borderSide: const BorderSide(width: .4, color: AppColors.grayColor),
                           ),
                           hintText: 'رقم الطلب',
                           hintMaxLines: 1,
                           filled: true,
                           enabled: true,
                           fillColor: Color(0xff45C1A6).withOpacity(0.05),
                         ),
                       ),
                     ),
                   ),

                   SizedBox(width: Get.height*0.02,),
                   Container(
                     width: Get.width*0.25,
                     child: GetBuilder<OrderHistoryControllers>(init: controller,builder: (state)=>controller.type.isEmpty ?const SizedBox():
                     Padding(
                       padding:  EdgeInsets.only(top: Get.height*0.00),
                       child: CustomDropdown<String>(
                         maxlines: 5,
                         decoration: CustomDropdownDecoration(
                           closedBorderRadius: BorderRadius.circular(100),
                             closedFillColor:  Color(0xff45C1A6).withOpacity(0.05),
                             listItemStyle: TextStyle(fontSize: 11),
                             headerStyle: TextStyle(fontSize: 11),
                             hintStyle: TextStyle(fontSize: 11),
                             closedSuffixIcon: SizedBox(),

                             closedBorder: Border.all(color: Colors.black,width: 0.5),


                             searchFieldDecoration: SearchFieldDecoration(

                               suffixIcon: (onClear){
                                 return IconButton(splashRadius: 20,onPressed:  onClear, icon: Icon(Icons.close,color: AppColors.secondaryColor,));
                               },
                               prefixIcon: Icon(Icons.search,color: AppColors.secondaryColor,),
                             )
                         ),
                         closedHeaderPadding: EdgeInsets.only(top: Get.height*0.015,bottom: Get.height*0.015,right: Get.width*0.06,left: Get.width*0.01),
                         items: controller.type.map((element) => element.name.toString().tr).toList(),
                         excludeSelected: false,

                         // hintText: 'نوع التوصيل',


                         onChanged: (value)async {
                           if(value!=TranslationKeys.all.tr && value!=TranslationKeys.all)
                           {
                             controller.typeId.value=controller.type.value.where((element) => element.name==value).first.id.toString();
                           }
                           else
                           {
                             controller.typeId.value='all';
                           }
                           controller.typeName.value =value;
                           controller.update();
                         },
                       ),
                     ),),
                   ),
                   SizedBox(width: Get.height*0.02,),

                   Container(
                       width: Get.width*0.20,
                       height: Get.height*0.06,
                       child: TextFormField(
                           textDirection: TextDirection.ltr,
                           readOnly: true,
                           enabled: true,
                           controller: controller.dateController,
                           maxLines: 1,
                           decoration: InputDecoration(
                                filled: true,
                               fillColor: Color(0xff45C1A6).withOpacity(0.05),
                               prefix: controller.isClearDate.value?
                               InkWell(
                                   onTap: (){
                                     controller.isClearDate.value=false;
                                     controller.dateController.clear();
                                     controller.filterProduct();
                                   }, child: const Icon(Icons.clear,color: AppColors.secondaryColor,size: 15,)):null,
                               contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                               hintStyle: const TextStyle(color: AppColors.grayColor,fontSize: 11),
                               alignLabelWithHint: true,
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
                               hintText: TranslationKeys.date.tr
                           ),
                           onTap: (){
                             DatePicker.showDatePicker(context, showTitleActions: true,
                                 minTime:DateTime(2024, 1, 1),
                                 maxTime: DateTime.now(),
                                 onConfirm: (date) {
                                   controller.dateController.text=intl.DateFormat('yyyy-MM-dd').format(date).toString();
                                   controller.isClearDate.value=true;
                                   controller.filterProduct();
                                 },
                                 currentTime:DateTime.now(),theme: const picker_theme.DatePickerTheme(doneStyle: TextStyle(color: AppColors.basicColor),));
                           },
                           textAlign: TextAlign.center,
                           style: const TextStyle(color: Colors.black,fontSize: 11))
                   ),
                 ],)
               ],)

              ],
            ),
          ),
          Container(
            height: controller.keyboardVisibility.value? Get.height/3.5 :Get.height/2,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.tapController, children:
            [
              controller.changeIndexState.value? loadingPage():  Container(height: Get.height*0.7,width: Get.width,margin: const EdgeInsets.only(top:0,left: 20,right: 20),child:
              controller.orderHistory.isEmpty ? ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
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
                  child:GetBuilder<OrderHistoryControllers>(init:controller,builder: (set)=>AnimationLimiter(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: Get.height*0.01),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.orderHistory.length,
                        itemBuilder: (context,index){
                          OrderModel item =controller.orderHistory[index];
                          return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 2,
                              child: ScaleAnimation(
                                  duration: const Duration(milliseconds: 900),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                    child:  Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ALOrderHistory(
                                        key: UniqueKey(),
                                        onTap: () {
                                          if (item != null && item.num != null) {
                                            Get.toNamed(
                                              Routes.OrderDetails,
                                              arguments: {'order': item, 'title': controller.title.tr},
                                            );
                                          } else {
                                            Get.snackbar('خطأ', 'تعذر تحميل تفاصيل الطلب، الطلب غير متوفر');
                                          }
                                        },

                                        orderHistoryM: item,
                                      ),
                                    ),)));
                        }),)))),

              controller.changeIndexState.value? loadingPage():  Container(height: Get.height*0.7,width: Get.width,margin: const EdgeInsets.only(top:0,left: 20,right: 20),child:
              controller.orderHistory.isEmpty ? ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
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
                  child:GetBuilder<OrderHistoryControllers>(init:controller,builder: (set)=>AnimationLimiter(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: Get.height*0.01),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.orderHistory.length,
                        itemBuilder: (context,index){
                          OrderModel item =controller.orderHistory[index];
                          return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 2,
                              child: ScaleAnimation(
                                  duration: const Duration(milliseconds: 900),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                    child:  Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ALOrderHistory(
                                        key: UniqueKey(),
                                        onTap: () {
                                          if (item != null && item.num != null) {
                                            Get.toNamed(
                                              Routes.OrderDetails,
                                              arguments: {'order': item, 'title': controller.title.tr},
                                            );
                                          } else {
                                            Get.snackbar('خطأ', 'تعذر تحميل تفاصيل الطلب، الطلب غير متوفر');
                                          }
                                        },

                                        orderHistoryM: item,
                                      ),
                                    ),)));
                        }),)))),

              controller.changeIndexState.value? loadingPage():  Container(height: Get.height*0.7,width: Get.width,margin: const EdgeInsets.only(top:0,left: 20,right: 20),child:
              controller.orderHistory.isEmpty ? ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
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
                  child:GetBuilder<OrderHistoryControllers>(init:controller,builder: (set)=>AnimationLimiter(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: Get.height*0.01),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.orderHistory.length,
                        itemBuilder: (context,index){
                          OrderModel item =controller.orderHistory[index];
                          return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 2,
                              child: ScaleAnimation(
                                  duration: const Duration(milliseconds: 900),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                    child:  Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ALOrderHistory(
                                        key: UniqueKey(),
                                        onTap: () {
                                          if (item != null && item.num != null) {
                                            Get.toNamed(
                                              Routes.OrderDetails,
                                              arguments: {'order': item, 'title': controller.title.tr},
                                            );
                                          } else {
                                            Get.snackbar('خطأ', 'تعذر تحميل تفاصيل الطلب، الطلب غير متوفر');
                                          }
                                        },

                                        orderHistoryM: item,
                                      ),
                                    ),)));
                        }),)))),



            ],
            ),
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





