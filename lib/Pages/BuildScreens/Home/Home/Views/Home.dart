


import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// SpinKitWave(color:AppColors.secondaryColor, size: 15,)
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
// import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALSettings/ALSettings.dart';
import 'package:shopping_land_delivery/ALWidget/ALCategory.dart';
import 'package:shopping_land_delivery/ALWidget/SLItem.dart';
import 'package:shopping_land_delivery/ALWidget/SLPost.dart';
import 'package:shopping_land_delivery/Model/Model/Agent.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Controllers/HomeController.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/ShowADV/Controllers/ControllersShowADV.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/ShowADV/Views/ShowADV.dart';
import 'package:shopping_land_delivery/Pages/MainScreenView/Controllers/MainScreenViewControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';


class Home extends StatefulWidget {
   Home({

     super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  HomeController controller=Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
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
                  return  Container(width: Get.width,height: Get.height,);
              }

        }),)));

  }

  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }

  Widget previewPage () {
    return  ListView(
      children: [
       SingleChildScrollView(
         physics: NeverScrollableScrollPhysics(),
         child: Column(children: [if(controller.advertisements.value.isNotEmpty  || !controller.isGetADV1.value)
           const SizedBox(height: 20,),
           if(controller.advertisements.value.isNotEmpty || !controller.isGetADV1.value)
             Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(25),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.1),
                     spreadRadius: 5,
                     blurRadius: 7,
                     offset: const Offset(0, 3), // changes position of shadow
                   ),
                 ],
               ),
               child:  !controller.isGetADV1.value ?
               Container(
                 width: Get.width*0.95,
                 height: Get.height*0.20,
                 child: Skeletonizer(
                     enabled: true,
                     child:Skeleton.unite(
                         borderRadius: BorderRadius.circular(0),
                         child : const Card(
                           color:Color(0xFFE8E8E8) ,
                           child: ListTile(
                             focusColor:Color(0xFFE8E8E8) ,
                           ),
                         )
                     )),
               ) :

               CustomCarouselSlider(

                 items:controller.advertisements.isEmpty?[]: controller.advertisements.value.map((e) => CarouselItem(
                   image:  ExtendedImage.network(
                       e.imageUrl.toString().replaceAll('\\', ''),
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
                   onImageTap: (i) {
                     showSlidingBottomSheet(
                       Get.context!,
                       builder: (ctx) => SlidingSheetDialog(
                           cornerRadius: 0,
                           snapSpec: const SnapSpec(initialSnap: 0.9, snappings: [0.9], snap: false),
                           builder: (BuildContext context,state) {
                             return   ShowADV(id:e.id.toString());
                           }),
                     ).then((value) =>Get.delete<ControllersShowADV>());

                   },
                 )).toList(),
                 height: Get.height*0.20,
                 //borderRadius: 0,
                 dotSpacing: 1,
                 width: Get.width*0.95,
                 autoplay: false,
                 showSubBackground: false,
                 showText: false,
                 selectedDotWidth: 6,
                 unselectedDotWidth: 4.5,
                 selectedDotHeight: 6,
                 unselectedDotHeight: 4.5,



                 unselectedDotColor: AppColors.grayColor,

                 selectedDotColor: AppColors.basicColor,
               ),
             ),

           if(controller.advertisements2.value.isNotEmpty || !controller.isGetADV2.value)
             const SizedBox(height: 10,),
           if(controller.advertisements2.value.isNotEmpty || !controller.isGetADV2.value)
             Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(25),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.1),
                     spreadRadius: 5,
                     blurRadius: 7,
                     offset: const Offset(0, 3), // changes position of shadow
                   ),
                 ],
               ),
               child:  !controller.isGetADV2.value ?
               Container(
                 width: Get.width*0.95,
                 height: Get.height*0.20,
                 child: Skeletonizer(
                     enabled: true,
                     child:Skeleton.unite(
                         borderRadius: BorderRadius.circular(0),
                         child : const Card(
                           color:Color(0xFFE8E8E8) ,
                           child: ListTile(
                             focusColor:Color(0xFFE8E8E8) ,
                           ),
                         )
                     )),
               ) :

               CustomCarouselSlider(
                 items:controller.advertisements2.isEmpty?[]: controller.advertisements2.value.map((e) => CarouselItem(
                   image:  ExtendedImage.network(
                       e.imageUrl.toString(),
                       headers: ALMethode.getApiHeader(),
                       fit: BoxFit.cover,
                       cache: true,
                       handleLoadingProgress: true,
                       timeRetry: const Duration(seconds: 1),
                       printError: true,
                       timeLimit  :const Duration(seconds: 1),
                       borderRadius: BorderRadius.circular(20),
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
                   onImageTap: (i) {
                     showSlidingBottomSheet(
                       Get.context!,
                       builder: (ctx) => SlidingSheetDialog(
                           cornerRadius: 0,
                           snapSpec: const SnapSpec(initialSnap: 0.9, snappings: [0.9], snap: false),
                           builder: (BuildContext context,state) {
                             return   ShowADV(id:e.id.toString());
                           }),
                     ).then((value) =>Get.delete<ControllersShowADV>());

                   },
                 )).toList(),
                 height: Get.height*0.20,
                 subHeight: 50,
                 //borderRadius: 0,
                 width: Get.width*0.95,
                 autoplay: false,
                 selectedDotWidth: 6,
                 unselectedDotWidth: 4.5,
                 selectedDotHeight: 6,
                 unselectedDotHeight: 4.5,

                 dotSpacing: 1,

                 showSubBackground: false,
                 showText: false,

                 unselectedDotColor: AppColors.grayColor,

                 selectedDotColor: AppColors.basicColor,
               ),
             ),
           const SizedBox(height: 20,),




           const SizedBox(height: 10,),

           if(!controller.isGetOptionWidget.value)
             Padding(
               padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
               child: Container(
                   width: Get.width,
                   height: Get.height*0.35,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(25),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.1),
                         spreadRadius: 5,
                         blurRadius: 7,
                         offset: const Offset(0, 3), // changes position of shadow
                       ),
                     ],
                   ),
                   child:
                   ListView.builder(itemCount: 10,
                       scrollDirection: Axis.horizontal,
                       physics: PageScrollPhysics(),
                       itemBuilder: (c,i){
                         return Container(
                           width: Get.width*0.5,
                           height: Get.height*0.35,
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15)
                           ),
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
                         );
                       })













               ),
             ),

           if(!controller.isGetPosts.value)
             Padding(
               padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
               child: Container(
                   width: Get.width,
                   height: Get.height*0.35,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(25),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.1),
                         spreadRadius: 5,
                         blurRadius: 7,
                         offset: const Offset(0, 3), // changes position of shadow
                       ),
                     ],
                   ),
                   child: Container(
                     width: Get.width*0.5,
                     height: Get.height*0.35,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(15)
                     ),
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













               ),
             ),

         ],),
       ),
      if(controller.optionWidget.value.isNotEmpty)
        Stack(
            children: [
              SingleChildScrollView(


                child: Column(
                  children: [
                    ListView.builder(

                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.optionWidget.length,
                        itemBuilder:  (c,index) {
                          final parent =controller.optionWidget[index];
                          return
                            Padding(
                              padding: const EdgeInsets.only(right:5,left: 5),
                              child: Container(
                                  width: Get.width*0.5,
                                  height: Get.height*0.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:10,left: 10),
                                        child: Text(parent.name.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800)),
                                      ),
                                      Container(
                                        width: Get.width,
                                        height: Get.height*0.42,

                                        child: AnimationLimiter(
                                            child: ListView.builder(itemCount: parent.items!.length,
                                                scrollDirection: Axis.horizontal,

                                                itemBuilder: (c,indexItem){
                                                  var item =parent.items![indexItem];
                                                  return AnimationConfiguration.staggeredGrid(
                                                      position: indexItem,
                                                      duration: const Duration(milliseconds: 500),
                                                      columnCount: 2,
                                                      child: ScaleAnimation(
                                                          duration: const Duration(milliseconds: 900),
                                                          curve: Curves.fastLinearToSlowEaseIn,
                                                          child: FadeInAnimation(child:
                                                          Padding(
                                                            padding: const EdgeInsets.all(4.0),
                                                            child: Container(
                                                                width: Get.width*0.55,
                                                                height: Get.height*0.43,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.grey.withOpacity(0.5),
                                                                        spreadRadius: 0.5,
                                                                        blurRadius: 1,
                                                                        offset: Offset(0, 1), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                    borderRadius: BorderRadius.circular(15)
                                                                ),
                                                                child: InkWell(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  onTap: ()async{
                                                                    FlutterStatusbarcolor.setNavigationBarColor(AppColors.whiteColor);
                                                                    FlutterStatusbarcolor.setStatusBarColor(AppColors.whiteColor);
                                                                    Get.toNamed(Routes.ItemsDetails,arguments:item )!.then((value) async {
                                                                      await FlutterStatusbarcolor.setNavigationBarColor(AppColors.basicColor);
                                                                      FlutterStatusbarcolor.setStatusBarColor(AppColors.whiteColor);
                                                                    });
                                                                  },
                                                                  child: SLItem(
                                                                    controller: controller,
                                                                    onLike: (Items item){
                                                                      item.isFav!.value=item.isFav!.value==0?1:0;
                                                                      controller.add_item_or_cancel_favourite(item);

                                                                    },
                                                                    item: item,
                                                                  ),
                                                                )
                                                            ),
                                                          ))));
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

        if(controller.post.value.isNotEmpty)
          SizedBox(height: 20,),
        if(controller.post.value.isNotEmpty)
          Stack(
              children: [
                SingleChildScrollView(


                  child: Column(
                    children: [
                      AnimationLimiter(
                        child: ListView.builder(
                            // physics: PageScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: controller.post.length,
                            itemBuilder:  (c,index) {
                              final post =controller.post[index];
                              return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  columnCount: 2,
                                  child: ScaleAnimation(
                                      duration: const Duration(milliseconds: 900),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: FadeInAnimation(child:
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 0.5,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: SLPost(
                                              onLike: (post){
                                                post.isLike!.value=post.isLike!.value==0?1:0;
                                                controller.like_or_unlike(post);
                                              },
                                              controller:controller,
                                              key: UniqueKey(),
                                              post: post,
                                            )
                                        ),
                                      ))));
                            }),
                      ),
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