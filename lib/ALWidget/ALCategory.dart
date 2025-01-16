


import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';

class ALCategory extends StatefulWidget {
  Category category;
   ALCategory({super.key,required this.category});

  @override
  State<ALCategory> createState() => _ALCategoryState();
}

class _ALCategoryState extends State<ALCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Container(
              decoration: BoxDecoration( boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              ),
              child:ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ExtendedImage.network(
                    widget.category.imageUrl.toString(),
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
                              height: Get.height*0.16,
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
              ),
            ),
          ),
          SizedBox(height: 2,),
          Expanded(child: Text(widget.category.name.toString(),textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w800),))
        ],
      ),
    );
  }
}
