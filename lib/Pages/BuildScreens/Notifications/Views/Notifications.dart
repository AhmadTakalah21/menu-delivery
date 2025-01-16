import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALWidget/AlNotifications.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Notifications/Controllers/NotificationsControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  NotificationsControllers controller = Get.put(NotificationsControllers());


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(systemNavigationBarColor: Color(0xfff8f8f8),statusBarIconBrightness: Brightness.light, systemNavigationBarIconBrightness: Brightness.light, systemNavigationBarDividerColor: AppColors.basicColor), child: Material(color: Colors.transparent,
        child: SafeArea(child:AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.white,
                systemNavigationBarDividerColor: AppColors.whiteColor
            ), child: Material(
            child: Container(
                decoration: BoxDecoration(

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
                    switch (controller.pageState.value)
                    {
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
                        return  SizedBox(width: Get.width,height: Get.height,);
                    }}),)))))));
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
                            Text(TranslationKeys.notifications.tr,style: const TextStyle(fontSize: 21,fontWeight: FontWeight.w700),),
                          ],
                        ),

                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
          Expanded(child:  Container(child:
          controller.pageStateProduct.value==1 && controller.notifications.isEmpty? ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
          controller.pageStateProduct.value==0  ? loadingPage():
          Stack(
            children: [
              GetX<NotificationsControllers>(init:controller,builder: (set)=>Container(
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
                    child: Container(

                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.basicColor,width: 1)
                      ),
                      child: ListView.builder(
                          physics:NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.notifications.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item =controller.notifications.value[index];

                            return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                child: ScaleAnimation(
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                      child:  Column(
                                        children: [
                                          AlNotifications(
                                              key: UniqueKey(),
                                              notificationsModel: item,
                                              index: index+1 ==controller.notifications.length ? 0 : index,

                                          ),
                                          Container(padding: EdgeInsets.only(left: 15,right: 15),color: Colors.white,child: Divider(color: Colors.grey,))
                                        ],
                                      ),)));
                          }),
                    ),),
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
