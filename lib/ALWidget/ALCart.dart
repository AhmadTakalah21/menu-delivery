


import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/CartModel.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';


typedef ONEdite = void Function();
typedef ONDelete = void Function();

class ALCart extends StatefulWidget {
  Carts carts;
  ONEdite onEdite;
  ONDelete onDelete;
  CartControllers controller;
  String totalPriceAfterDiscount;
   ALCart({
     required this.totalPriceAfterDiscount,
     required this.controller,
     required this.carts,
     required this.onEdite,
     required this.onDelete,
    super.key});

  @override
  State<ALCart> createState() => _ALCartState();
}

class _ALCartState extends State<ALCart> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartControllers>(init: widget.controller,builder: (set)=> Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow:[BoxShadow(
            color: Colors.grey,
            spreadRadius: 0.1,
            blurRadius: 0.5,
            offset: const Offset(0, 1), // changes position of shadow
          )],
        color:  Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: .2,color: AppColors.grayColor)),
      child:
      Stack(
        alignment: Alignment.topLeft,
        children: [
          // SizedBox(width: Get.width*0.05,height: Get.width*0.05,child: FloatingActionButton(heroTag: Uuid().v4().toString(),onPressed: widget.onDelete,elevation: 2,backgroundColor: AppColors.readColor,child: Icon(Icons.clear,color: AppColors.whiteColor,size: 15,))),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            Expanded(child:Container(
              child:Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: ExtendedImage.network(
                        widget.carts.item!.image!.url.toString(),
                        width: Get.width*0.3,
                        height: Get.width*0.4,
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
                                  width: Get.width*0.3,
                                  height: Get.width*0.4,
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
                                    width: Get.width*0.3,
                                    height: Get.width*0.4,
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
                  ),
                   SizedBox(width: Get.width*0.03,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(widget.carts.item!.name.toString(),style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 19),),
                    const SizedBox(height: 5,),
                      Text(widget.carts.item!.brandName.toString(),style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 16),),
                      Text(widget.carts.item!.name.toString(),style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                      SizedBox(height: Get.width*0.02,),
                     for(int i =0;i<widget.carts.cartDetail!.length;i++)
                       Row(children: [
                         Text(widget.carts.cartDetail![i].name.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
                         SizedBox(width: Get.width*0.02,),
                         Container(
                           padding: EdgeInsets.only(left: Get.width*0.08,right: Get.width*0.08,top: Get.height*0.012,bottom: Get.height*0.012),
                           decoration: BoxDecoration(
                               color: Color(0xffF5F5F5),
                               borderRadius: BorderRadius.circular(100),
                               border: Border.all(color:Color(0xffF5F5F5),width: 0.3),
                           ),
                           child: Text(widget.carts.cartDetail![i].measurements!.first.name.toString(),style:TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color:Color(0xff4B4B4B) ) ),
                         )
                       ],),
                      SizedBox(height: Get.width*0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(width: Get.width*0.36,child: Text(ALMethode.formatNumberWithSeparators(widget.carts.price.toString()),style: const TextStyle(color: AppColors.secondaryColor,fontWeight: FontWeight.w800,fontSize: 19),)),

                          Container(
                            padding: EdgeInsets.only(left: Get.width*0.08,right: Get.width*0.08,top: Get.height*0.012,bottom: Get.height*0.012),
                            decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color:Color(0xffF5F5F5),width: 0.3),
                            ),
                            child: Text( widget.carts.quantity.toString(),style:TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color:Color(0xff4B4B4B) ) ),
                          )

                        ],
                      ),

                  ],)
                ],
              ) ,
            )),


          ]

          ),
        ],
      )),
    );
  }
}


