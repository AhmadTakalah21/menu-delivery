


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';

class SLWidgetText extends StatefulWidget {

  String title;
  Color backGroundColor;
  bool lightBorder;
  bool isActive;
  SLWidgetText({
    required this.title,
    required this.backGroundColor,
    required this.isActive,
    required this.lightBorder,
    super.key
  });

  @override
  State<SLWidgetText> createState() => _SLWidgetTextState();
}

class _SLWidgetTextState extends State<SLWidgetText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Get.width*0.045,right: Get.width*0.045,top: Get.height*0.008,),
      decoration: BoxDecoration(
        color: widget.isActive?widget.backGroundColor:Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color:widget.isActive ? widget.backGroundColor :widget.lightBorder?AppColors.grayColor:Colors.black,width: 0.3),
        boxShadow: widget.isActive? [BoxShadow(
          color: Colors.grey,
          spreadRadius: 0.1,
          blurRadius: 0.5,
          offset: const Offset(0, 1), // changes position of shadow
        )]:null
      ),
      child: Text(widget.title,style:TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color:widget.isActive?Colors.white: widget.lightBorder? AppColors.grayColor:Color(0xff4B4B4B) ) ),
      );
  }
}
