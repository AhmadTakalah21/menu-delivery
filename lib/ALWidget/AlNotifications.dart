


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/Model/Model/NotificationsModel.dart';

class AlNotifications extends StatefulWidget {
  NotificationsModel notificationsModel;
  int index;
   AlNotifications({
    required this.notificationsModel,
     required this.index,
    super.key
  });

  @override
  State<AlNotifications> createState() => _AlNotificationsState();
}

class _AlNotificationsState extends State<AlNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(

      width: Get.width,
      height: Get.height*0.12,
      padding:const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.notificationsModel.title.toString(),style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w700,),maxLines: 1,)),

              Text(widget.notificationsModel.date.toString(),style: TextStyle(color: Colors.grey,fontSize: 12),)

            ],
          ),
          Expanded(child: Text(widget.notificationsModel.body.toString(),style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)),

        ],
      ),);
  }
}
