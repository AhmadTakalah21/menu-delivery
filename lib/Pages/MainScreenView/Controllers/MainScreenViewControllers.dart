


import 'dart:convert';

import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ClassModel/Convex.dart';
import 'package:shopping_land_delivery/Model/Model/Agent.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';
import 'package:shopping_land_delivery/Model/Model/Cities.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Controllers/HomeController.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Repositories/HomeRepositories.dart';
import 'package:shopping_land_delivery/Pages/SignUp/Repositories/SingUpRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class MainScreenViewControllers extends GetxController
{
  RxInt indexScreen=0.obs;
  late List<BottomBarItem> listConvex=[];
  RxList<Agent> agent =<Agent>[].obs;
  RxList<Cities> cities =<Cities>[].obs;
  RxList<Category> category =<Category>[].obs;
  RxString citiesName = ''.obs;

  MainScreenViewControllers(){
    listConvex=[

      BottomBarItem(iconSize: 25,iconData: CupertinoIcons.home),
      BottomBarItem(iconSize: 25,iconData: CupertinoIcons.square_grid_2x2),
      BottomBarItem(iconSize: 25,iconData: Icons.favorite_border),
      BottomBarItem(iconSize: 25,iconData: CupertinoIcons.cart),
      BottomBarItem(iconSize: 25,iconData: CupertinoIcons.person),

    ];
  }

  Future<void> display_all_cities() async{

    SingUpRepositories repositories  =SingUpRepositories();
    if(await repositories.display_all_cities())
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        cities.value =dataCitiesFromJson(json.encode(data['cities']));
        citiesName.value=cities.first.name.toString();
        alSettings.citiesId.value=cities.first.id.toString();
        alSettings.currentUser!.citiesId=alSettings.citiesId.value;
        ALMethode.setUserInfo(data: alSettings.currentUser!);
        update();
      }

    }
  }

  
  @override
  void onInit() {

    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 2),(){
      FlutterStatusbarcolor.setNavigationBarColor(AppColors.basicColor);
      FlutterStatusbarcolor.setStatusBarColor(AppColors.basicColor);
    });
    // display_all_cities();
  }
}