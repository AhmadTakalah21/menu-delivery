import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/BrandsDetails/Controllers/BrandsDetailsControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Favorite/Controllers/FavoriteControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Controllers/HomeController.dart';
import 'package:shopping_land_delivery/main.dart';

typedef OnLike = void Function(Items);

class SLItem extends StatefulWidget {
  Items item;

  dynamic controller;
  OnLike onLike;

  SLItem(
      {required this.controller,
      required this.item,
      required this.onLike,
      super.key});

  @override
  State<SLItem> createState() => _SLItemState();
}

class _SLItemState extends State<SLItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ExtendedImage.network(
                widget.item.image!.url
                    .toString()
                    .replaceAll('\\', '')
                    .replaceAll(' ', '%20'),
                headers: ALMethode.getApiHeader(),
                fit: BoxFit.cover,
                cache: true,
                height: Get.height,
                handleLoadingProgress: true,
                timeRetry: const Duration(seconds: 1),
                printError: true,
                timeLimit: const Duration(seconds: 1),
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
                      child: const Icon(
                        CupertinoIcons.refresh_circled_solid,
                        size: 40,
                        color: AppColors.basicColor,
                        semanticLabel: 'failed',
                      ),
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
                      Container(
                        child: Platform.isAndroid
                            ? const CircularProgressIndicator(
                                color: AppColors.grayColor,
                                strokeWidth: 1,
                                backgroundColor: AppColors.whiteColor,
                              )
                            : CupertinoActivityIndicator(radius: 15),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.controller.runtimeType == HomeController)
                GetBuilder<HomeController>(
                    init: widget.controller,
                    builder: (builder) => Container(
                          width: Get.height * 0.07,
                          height: Get.height * 0.07,
                          margin: EdgeInsets.only(bottom: Get.height * 0.00),
                          child: LikeButton(
                            size: 30,
                            onTap: (value) async {
                              await Future.delayed(Duration(seconds: 1), () {
                                widget.item.isFavChange = true;

                                widget.onLike(widget.item);
                              });
                              return true;
                            },
                            isLiked: widget.item.isFavChange
                                ? null
                                : widget.item.isFav!.value == 1
                                    ? true
                                    : false,
                            likeCount: widget.item.countFavourites,
                            circleColor: CircleColor(
                                start: AppColors.readColor,
                                end: AppColors.readColor),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: AppColors.readColor,
                              dotSecondaryColor: AppColors.readColor,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color:
                                    isLiked ? AppColors.readColor : Colors.grey,
                                size: 30,
                              );
                            },
                          ),
                        ))
              else if (widget.controller.runtimeType == FavoriteControllers)
                GetBuilder<FavoriteControllers>(
                    init: widget.controller,
                    builder: (builder) => Container(
                          width: Get.height * 0.07,
                          height: Get.height * 0.07,
                          margin: EdgeInsets.only(bottom: Get.height * 0.00),
                          child: LikeButton(
                            size: 30,
                            onTap: (value) async {
                              await Future.delayed(Duration(seconds: 1), () {
                                widget.item.isFavChange = true;

                                widget.onLike(widget.item);
                              });
                              return true;
                            },
                            isLiked: widget.item.isFavChange
                                ? null
                                : widget.item.isFav!.value == 1
                                    ? true
                                    : false,
                            likeCount: widget.item.countFavourites,
                            circleColor: CircleColor(
                                start: AppColors.readColor,
                                end: AppColors.readColor),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: AppColors.readColor,
                              dotSecondaryColor: AppColors.readColor,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color:
                                    isLiked ? AppColors.readColor : Colors.grey,
                                size: 30,
                              );
                            },
                          ),
                        ))
              else
                GetBuilder<BrandsDetailsControllers>(
                    init: widget.controller,
                    builder: (builder) => Container(
                          width: Get.height * 0.07,
                          height: Get.height * 0.07,
                          margin: EdgeInsets.only(bottom: Get.height * 0.00),
                          child: LikeButton(
                            size: 30,
                            onTap: (value) async {
                              await Future.delayed(Duration(seconds: 1), () {
                                widget.item.isFavChange = true;

                                widget.onLike(widget.item);
                              });
                              return true;
                            },
                            isLiked: widget.item.isFavChange
                                ? null
                                : widget.item.isFav!.value == 1
                                    ? true
                                    : false,
                            likeCount: widget.item.countFavourites,
                            circleColor: CircleColor(
                                start: AppColors.readColor,
                                end: AppColors.readColor),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: AppColors.readColor,
                              dotSecondaryColor: AppColors.readColor,
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color:
                                    isLiked ? AppColors.readColor : Colors.grey,
                                size: 30,
                              );
                            },
                          ),
                        )),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                height: Get.height * 0.1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(right: 2),
                            width: Get.width * 0.2,
                            child: Text(
                              widget.item.brandName.toString(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.grayColor),
                            )),
                        Container(
                            padding: EdgeInsets.only(right: 2),
                            width: Get.width * 0.2,
                            child: Text(
                              widget.item.name.toString(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.item.priceAfterOffer != null &&
                              widget.item.priceAfterOffer! > 0)
                            Text(
                              ALMethode.formatNumberWithSeparators(
                                  widget.item.priceAfterOffer.toString() +
                                      alSettings.currency),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.grayColor),
                            ),
                          Text(
                            ALMethode.formatNumberWithSeparators(
                                widget.item.price.toString() +
                                    alSettings.currency),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
