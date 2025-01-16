

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:shopping_land_delivery/Model/Model/ShowADVModel.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/ShowADV/Repositories/RepositoriesShowADV.dart';

class ControllersShowADV extends GetxController
{
  String id='';
  RxInt statePage = 0.obs;
  RxString htmlData=''.obs;
  RxBool checkedValue=false.obs;
  String language='';
  ShowADVModel avd = ShowADVModel();
  Future<void> get_one_adv() async{
    statePage.value=0;

    RepositoriesShowADV repositories  =RepositoriesShowADV();
    if(await repositories.get_one_adv(body: {'advId':id}) )
    {
      var data = json.decode(json.decode(repositories.message.data));
      avd=dataItemStoreCategoryFromJson([json.encode(data)].toString()).first;
      statePage.value=1;
    }
    else
    {
      statePage.value=2;
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 1),(){
      get_one_adv();
    });
  }


}