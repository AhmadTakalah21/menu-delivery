import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/Post.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Controllers/HomeController.dart';

typedef OnLike = void Function(PostModel);

class SLPost extends StatefulWidget {
  PostModel post;
  HomeController controller;
  OnLike onLike;

  SLPost(
      {required this.post,
      required this.onLike,
      required this.controller,
      super.key});

  @override
  State<SLPost> createState() => _SLPostState();
}

class _SLPostState extends State<SLPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.basicColor.withOpacity(0.1),
      constraints: widget.post.files != null && widget.post.files!.isNotEmpty
          ? null
          : BoxConstraints(maxHeight: Get.height * 0.3),
      child: Column(
        mainAxisAlignment:
            widget.post.files != null && widget.post.files!.isNotEmpty
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Text(
                    widget.post.title.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: Text(
                    widget.post.description.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 20,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.post.files != null && widget.post.files!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomCarouselSlider(
                items: widget.post.files!.isEmpty
                    ? []
                    : widget.post.files!
                        .map((e) => CarouselItem(
                              image: ExtendedImage.network(
                                  e.url.toString().replaceAll('\\', ''),
                                  headers: ALMethode.getApiHeader(),
                                  fit: BoxFit.cover,
                                  cache: true,
                                  height: Get.height * 0.2,
                                  handleLoadingProgress: true,
                                  timeRetry: const Duration(seconds: 1),
                                  printError: true,
                                  timeLimit: const Duration(seconds: 1),
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
                                        height: Get.height * 0.20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                          height: Get.height * 0.20,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        Container(
                                          child: Platform.isAndroid
                                              ? const CircularProgressIndicator(
                                                  color: AppColors.grayColor,
                                                  strokeWidth: 1,
                                                  backgroundColor:
                                                      AppColors.whiteColor,
                                                )
                                              : CupertinoActivityIndicator(
                                                  radius: 15),
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
                                // showSlidingBottomSheet(
                                //   Get.context!,
                                //   builder: (ctx) => SlidingSheetDialog(
                                //       cornerRadius: 0,
                                //       snapSpec: const SnapSpec(initialSnap: 0.9, snappings: [0.9], snap: false),
                                //       builder: (BuildContext context,state) {
                                //         return   ShowADV(id:e.id.toString());
                                //       }),
                                // );
                              },
                            ))
                        .toList(),
                height: Get.height * 0.20,
                selectedDotWidth: 6,
                unselectedDotWidth: 4.5,
                selectedDotHeight: 6,
                unselectedDotHeight: 4.5,
                // borderRadius: 15,
                dotSpacing: 1,
                width: Get.width * 0.90,
                autoplay: false,
                showSubBackground: false,
                showText: false,

                unselectedDotColor: AppColors.grayColor,

                selectedDotColor: AppColors.basicColor,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16, top: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GetBuilder<HomeController>(
                      init: widget.controller,
                      builder: (builder) => Container(
                            margin: EdgeInsets.only(bottom: Get.height * 0.00),
                            child: LikeButton(
                              size: 20,
                              onTap: (value) async {
                               await Future.delayed(Duration(seconds: 1), () {
                                  widget.post.isFavChange = true;

                                  widget.onLike(widget.post);
                                });
                                return true;
                              },
                              isLiked: widget.post.isFavChange
                                  ? null
                                  : widget.post.isLike!.value == 1
                                      ? true
                                      : false,
                              circleColor: CircleColor(
                                  start: AppColors.readColor,
                                  end: AppColors.readColor),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: AppColors.readColor,
                                dotSecondaryColor: AppColors.readColor,
                              ),
                              likeCount: widget.post.counterLikes,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  isLiked
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: isLiked
                                      ? AppColors.readColor
                                      : Colors.grey,
                                  size: 20,
                                );
                              },
                            ),
                          )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
