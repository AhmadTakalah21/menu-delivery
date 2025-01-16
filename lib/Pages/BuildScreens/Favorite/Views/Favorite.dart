








import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALWidget/SLItem.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Favorite/Controllers/FavoriteControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {


  FavoriteControllers controller = Get.put(FavoriteControllers());
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: AppColors.basicColor,
            systemNavigationBarDividerColor: AppColors.basicColor
        ), child: Material(
        child:Scaffold(
          
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


                Container(padding: EdgeInsets.only(top: 10),height: Get.height*0.06,width: Get.width,alignment: Alignment.center,child: Text('المفضلة'.toString(),style: TextStyle(color: AppColors.grayColor,fontSize: 18,fontWeight: FontWeight.w600),)),


                if(!controller.isGetFavourites.value)
                  Container(
                    height: Get.height*0.8,
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



                if(!controller.isGetFavourites.value)
                  SizedBox(height: Get.height*0.01,),




              ],
            ),
          ),

          if(controller.isGetFavourites.value)
            Expanded(child:  Container(
                padding: EdgeInsets.only(top: Get.width*0.04),

                child:
            controller.optionWidget.isEmpty? ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
            Stack(
              children: [
                GetX<FavoriteControllers>(init:controller,builder: (set)=>Container(
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
                          itemCount: controller.optionWidget.length,
                          itemBuilder: (BuildContext context, int index) {
                            dynamic item =  controller.optionWidget[index];

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
                                          child:  SLItem(
                                                  controller: controller,
                                                  item: item,
                                                  onLike: (Items item){
                                                    item.isFav!.value=item.isFav!.value==0?1:0;
                                                    controller.add_item_or_cancel_favourite(item);
                                                    controller.optionWidget.removeAt(index);
                                                  }
                                              )
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
