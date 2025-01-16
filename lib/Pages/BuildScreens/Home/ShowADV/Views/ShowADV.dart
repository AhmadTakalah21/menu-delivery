import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/ShowADV/Controllers/ControllersShowADV.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';


class ShowADV extends StatefulWidget {
  String id;
   ShowADV({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<ShowADV> createState() => _ShowADVState();
}

class _ShowADVState extends State<ShowADV> {
  ControllersShowADV controller= Get.put(ControllersShowADV());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.id=widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: DefaultTextStyle(style: const TextStyle(color:Colors.white,),
        child: Container(
            color: Colors.white,
            height: Platform.isAndroid ? Get.height*0.89 : Get.height*0.88 ,
            width: Get.width,
            child: Obx(() {
              switch(controller.statePage.value)
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
                  return const SizedBox();
              }
            })
    )));
  }


  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }

  Widget previewPage()
  {
    return
      SingleChildScrollView(child:
      Padding(
          padding: EdgeInsets.only(bottom: Get.height/10,top: 10,left: 5,right: 5),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

            ExtendedImage.network(
                controller.avd.imageUrl.toString(),
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
                          height: Get.height*0.16,
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
                            height: Get.height*0.2,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               Text(TranslationKeys.dateStart.tr+': '+controller.avd.fromDate.toString(),style: TextStyle(color: Colors.black,fontSize: 15), ),
               Text(TranslationKeys.dateEnd.tr+': '+controller.avd.toDate.toString(),    style: TextStyle(color: Colors.black,fontSize: 15), ),

                         ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: Get.width,
                height: Get.height*0.34,
                child: ListView(

                  children: [
                    Text(controller.avd.title.toString(),style: TextStyle(color: Colors.black,fontSize: 15)),
                  ],
                ),
              ),
            )
      ]
      )));
  }
  Widget errorPage () {
    return ALConstantsWidget.errorServer(callBack: (){
      controller.onInit();
    });
  }

}
