

import 'package:flutter/material.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/Portfolio.dart';

class ALWithdrawals extends StatefulWidget {
  Sell withdrawals;
  ALWithdrawals({
    super.key,
    required this.withdrawals
  });

  @override
  State<ALWithdrawals> createState() => _ALWithdrawalsState();
}

class _ALWithdrawalsState extends State<ALWithdrawals> {
  @override
  Widget build(BuildContext context) {
    return Container(padding:  EdgeInsets.all(5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(widget.withdrawals.date.toString(),style: const TextStyle(color: AppColors.grayColor,fontSize: 16,fontWeight: FontWeight.w600),)),
        Text(widget.withdrawals.amount.toString(),style: const TextStyle(color: AppColors.basicColor,fontSize: 16,fontWeight: FontWeight.w600),),
      ],
    ),);
  }
}
