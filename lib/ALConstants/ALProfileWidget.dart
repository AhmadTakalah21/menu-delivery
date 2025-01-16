


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ClassModel/ProfileModel.dart';


class ALProfileWidget extends StatefulWidget {
  ProfileModel profileModel;
   ALProfileWidget({
     required this.profileModel,
     super.key
   });

  @override
  State<ALProfileWidget> createState() => _ALProfileWidgetState();
}

class _ALProfileWidgetState extends State<ALProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800
      ),
      child: Padding(
        padding:  EdgeInsets.only(bottom: widget.profileModel.styleTypeType==ProfileModelStyleType.title || widget.profileModel.styleTypeType==ProfileModelStyleType.onTap ||  widget.profileModel.styleTypeType==ProfileModelStyleType.logOut? 8.0:0),
        child: Container(
          width: Get.width*0.95,
          height: Get.height*0.06,
          padding: EdgeInsets.all(Get.width*0.03),
          decoration: BoxDecoration(
            color: widget.profileModel.styleTypeType==ProfileModelStyleType.title?Color(0xffF5F5F5):  Colors.white,
            border:widget.profileModel.withBorder==null &&(widget.profileModel.styleTypeType==ProfileModelStyleType.title || widget.profileModel.styleTypeType==ProfileModelStyleType.logOut || widget.profileModel.styleTypeType==ProfileModelStyleType.onTap)? null : Border.all(color: widget.profileModel.type==ProfileModelType.logOut?AppColors.readColor: AppColors.grayColor,width: 0.5)
          ),
          child: Text(widget.profileModel.title.tr,textAlign: widget.profileModel.styleTypeType==ProfileModelStyleType.logOut?TextAlign.center:null,style: TextStyle(color:widget.profileModel.type==ProfileModelType.logOut?AppColors.readColor: AppColors.grayColor),),
        ),
      ),
    );
  }
}
