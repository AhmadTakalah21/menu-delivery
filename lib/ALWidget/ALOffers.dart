

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/Offers.dart';

import '../main.dart';

typedef OnTap = void Function(Items);

class ALOffers extends StatefulWidget {
  List<Items> items;
  OnTap onTap;
   ALOffers({
     super.key,
     required this.items,
     required this.onTap,

   });

  @override
  State<ALOffers> createState() => _ALOffersState();
}

class _ALOffersState extends State<ALOffers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height/3.5,
      child: ListView.builder(
      scrollDirection:Axis.horizontal ,
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          Items item =widget.items[index];

          return InkWell(
            onTap: (){
              widget.onTap(item);
            },
            child: Container(

           child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Container(
                  width: Get.width/3,
                  height: Get.height*0.16,
                  decoration: BoxDecoration( boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  ),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ExtendedImage.network(

                         item.itemImage.toString(),
                        headers: ALMethode.getApiHeader(),
                        fit: BoxFit.fill,
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
                                  width: Get.width/3,
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
                                    width: Get.width/3,
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
              const SizedBox(height: 2,),
              Container(
                width: Get.width/2.5,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(item.itemName.toString(),maxLines: 2,style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w800,overflow: TextOverflow.ellipsis),)),

                    Align(alignment: Alignment.centerLeft,child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(ALMethode.formatNumberWithSeparators('${item.itemPrice} ${alSettings.currency}'),style: const TextStyle(decoration: TextDecoration.lineThrough,color: AppColors.grayColor,fontSize: 11,fontWeight: FontWeight.w800,),),
                        const SizedBox(height: 3,),
                        Text(ALMethode.formatNumberWithSeparators('${item.itemOfferPrice} ${alSettings.currency}'),style: const TextStyle(color: AppColors.basicColor,fontSize: 11,fontWeight: FontWeight.w800),),

                      ],
                    ),)

                  ],
                ),
              )
            ],
                    ),
                  ),
          );
    }),);
  }
}
