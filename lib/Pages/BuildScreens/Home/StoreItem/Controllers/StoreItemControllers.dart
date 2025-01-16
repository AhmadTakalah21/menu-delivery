


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/Model/Model/ItemStore.dart';
import 'package:shopping_land_delivery/Model/Model/ItemStoreCategory.dart';
import 'package:shopping_land_delivery/Model/Model/Product.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/StoreItem/Repositories/StoreItemRepositories.dart';

class StoreItemControllers extends GetxController {

  late Product product;
  bool offer=false;
  RxInt pageStateProduct=0.obs;
  RxInt pageState=1.obs;
  Rx<ItemStoreCategory> itemStore =ItemStoreCategory().obs;
  TextEditingController controller =TextEditingController(text:'1');
  RoundedLoadingButtonController btnController =  RoundedLoadingButtonController();
  StoreItemControllers(){
    product=Get.arguments['product'];
    offer=Get.arguments['offers']??false;
  }

  



  Future<void> showItemStore() async{
    pageStateProduct.value=0;
    pageState.value=1;
    StoreItemRepositories repositories  =StoreItemRepositories();
    if(await repositories.show_item_store(bodyData: {'storeItemId':product.id.toString()}))
    {
      var data = json.decode(repositories.message.data);
      print('s');
      itemStore.value =dataItemStoreCategoryFromJson([data].toString()).first;
      pageStateProduct.value=1;
    }
    else
    {
      pageState.value=2;
    }
  }


  Future<void> addToCart() async{
    StoreItemRepositories repositories  =StoreItemRepositories();
    if(await repositories.add_to_cart(bodyData: {'storeItemId':product.id.toString(),'quantity':controller.text.trim().toString()}))
    {
      try
      {
        CartControllers controllers = Get.find();
        controllers.onInit();
      }
      catch(e){}
      btnController.success();
      await Future.delayed(const Duration(seconds: 1));
      btnController.reset();
      Get.back();
    }
    else
    {
      btnController.error();
      await Future.delayed(const Duration(seconds: 1));
      btnController.reset();
    }
  }
  
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    showItemStore();
    
  }

}