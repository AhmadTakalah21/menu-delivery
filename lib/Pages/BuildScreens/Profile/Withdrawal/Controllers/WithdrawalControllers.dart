

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/Model/Model/Portfolio.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Withdrawal/Repositories/WithdrawalRepositories.dart';

class WithdrawalControllers extends GetxController with GetTickerProviderStateMixin{

  RxInt pageState=1.obs;
  TextEditingController balanceWithdrawal= TextEditingController();
  ValueNotifier<TextDirection> balanceWithdrawalTextDirection = ValueNotifier(TextDirection.ltr);
  RxList<Portfolio> portfolio =<Portfolio>[].obs;
  late TabController tapController= TabController(length: 2,initialIndex: 0, vsync: this);
  GlobalKey<FormState> form = GlobalKey<FormState>();

  Future<void> show_withdrawals() async{
    pageState.value=0;
    WithdrawalRepositories repositories  =WithdrawalRepositories();
    if(await repositories.show_withdrawals(bodyData: {'user':'MUser'}))
    {
      if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          portfolio.value =dataWithdrawalsFromJson(json.encode([data]));
        }
      pageState.value=1;
    }
    else
    {
      pageState.value=2;
    }
  }


  Future<void> withdraw_money() async{
    if(Platform.isIOS)
    {
      SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native);
    }
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);

    SVProgressHUD.show();

    WithdrawalRepositories repositories  =WithdrawalRepositories();
    if(await repositories.withdraw_money(bodyData: {'amount':balanceWithdrawal.text.trim().toString()}))
    {
      SVProgressHUD.dismiss();
      onInit();
    }
    else
      {
        SVProgressHUD.dismiss();
      }
  }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    show_withdrawals();
  }
}