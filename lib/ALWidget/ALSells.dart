


import 'package:flutter/material.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/Portfolio.dart';

class ALSells extends StatefulWidget {
  Sells sell;
  ALSells({
    super.key,
    required this.sell
  });

  @override
  State<ALSells> createState() => _ALSellsState();
}

class _ALSellsState extends State<ALSells> {
  @override
  Widget build(BuildContext context) {
    return Container(padding:  EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(widget.sell.date.toString(),style: const TextStyle(color: AppColors.grayColor,fontSize: 16,fontWeight: FontWeight.w600),)),
          Text(widget.sell.orderPrice.toString(),style: const TextStyle(color: AppColors.basicColor,fontSize: 16,fontWeight: FontWeight.w600),),
        ],
      ),);

  }
}
