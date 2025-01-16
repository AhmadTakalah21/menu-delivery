


import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/BrandModel.dart';

class SLBrand extends StatefulWidget {
  BrandModel brandModel;
   SLBrand({
     required this.brandModel,
     super.key
   });

  @override
  State<SLBrand> createState() => _sdState();
}

class _sdState extends State<SLBrand> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(
          color: Colors.grey,
          spreadRadius: 0.1,
          blurRadius: 0.5,
          offset: const Offset(0, 1), // changes position of shadow
        )]
      ),
      child: Stack(

        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ExtendedImage.network(
                widget.brandModel.urlImage!.toString().replaceAll('\\', '').replaceAll(' ', '%20'),
                headers: ALMethode.getApiHeader(),
                fit: BoxFit.cover,
                cache: true,
                height: Get.height,
                handleLoadingProgress: true,
                timeRetry: const Duration(seconds: 1),
                printError: true,
                timeLimit  :const Duration(seconds: 1),
                borderRadius: BorderRadius.circular(15),
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
                          height: Get.height,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
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
                            height: Get.height,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(15),
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
          ),
          Container(

            decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
            ),
            height: Get.height*0.07,
            width: Get.width,
            child:Container(alignment: Alignment.center,child: Text(widget.brandModel.name.toString(),textAlign: TextAlign.center,maxLines: 1,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: Colors.black),)),

          )
        ],

      ),
    );
  }
}
