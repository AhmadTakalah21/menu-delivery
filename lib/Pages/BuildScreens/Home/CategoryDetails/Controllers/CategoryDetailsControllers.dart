

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';
import 'package:shopping_land_delivery/Model/Model/Product.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/CategoryDetails/Repositories/CategoryDetailsRepositories.dart';
import 'package:shopping_land_delivery/main.dart';

class CategoryDetailsControllers extends GetxController
{
  late Category category;
  RxInt pageState=1.obs;
  RxInt pageStateProduct=0.obs;
  RxInt pageStateSearch=1.obs;
  RxInt pageSearch=1.obs;
  RxBool pageSearchBool=false.obs;
  RxList<Product> product =<Product>[].obs;
  GlobalKey<SmartRefresherState> refreshKey = GlobalKey<SmartRefresherState>();

  RxList<Product> productSearch =<Product>[].obs;
  TextEditingController searchController=TextEditingController();
  late RefreshController refreshController ;
  bool empty =false;
  int page =2;
  RxBool showSearch = false.obs;
  RxBool isClear= false.obs;
  RxBool isSearch = false.obs;
  RxBool isClearSug = false.obs;
  FocusNode focusNode = FocusNode();

  late ValueNotifier<TextDirection> textDir ;
  CategoryDetailsControllers() {
    category =Get.arguments;
    textDir = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);
    refreshController= RefreshController(initialRefresh: false);
  }

  Future<void> getStore() async{
    page=2;
    pageStateProduct.value=0;
    pageState.value=1;
    CategoryDetailsRepositories repositories  =CategoryDetailsRepositories();

    Map<String,String> bodyData ={'agentId':alSettings.citiesId.toString(),'categoryId':category.id.toString()};
    if(searchController.text.trim().isNotEmpty)
      {
        bodyData.addAll({'search':searchController.text.trim()});
      }
    if(await repositories.store_search(bodyData: {'agentId':alSettings.citiesId.toString(),'categoryId':category.id.toString()}))
    {
      if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          product.value =dataProductFromJson(json.encode(data).toString());
        }
      pageStateProduct.value=1;
    }
    else
    {
      pageState.value=2;
    }
  }

  Future<void> filterProduct()async {
    CategoryDetailsRepositories repositories  =CategoryDetailsRepositories();
    pageStateSearch.value=0;
    page=2;
    if(await repositories.store_search(bodyData: {'search':searchController.text.trim(),'categoryId':category.id.toString(),'agentId':alSettings.citiesId.toString()}))
    {

      if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          productSearch.value =data!=null ?dataProductFromJson(json.encode(data).toString()):[];
        }
      pageStateSearch.value=1;
      pageSearchBool.value=false;
    }
    else
    {
      pageState.value=2;
    }

  }

  Future<void> getListOfRefresh()async{
      try{
        page=2;
        CategoryDetailsRepositories repositories  =CategoryDetailsRepositories();

        Map<String,String> bodyData ={'agentId':alSettings.citiesId.toString(),'categoryId':category.id.toString()};
        if(searchController.text.trim().isNotEmpty)
        {
          bodyData.addAll({'search':searchController.text.trim()});
        }
        if(await repositories.store_search(bodyData: bodyData))
        {
          var data = json.decode(json.decode(repositories.message.data));
          product.value =dataProductFromJson(json.encode(data).toString());
          refreshController.refreshCompleted();
        }
        else
          {
            refreshController.refreshFailed();
          }
      }
      catch(e) {
        refreshController.refreshFailed();
      }

  }

  Future<void> getListOfLoading()async{
    if(empty)
    {
      refreshController.loadNoData();
    }
    else
    {
      try{
        CategoryDetailsRepositories repositories  =CategoryDetailsRepositories();

        Map<String,String> bodyData ={'page':page.toString(),'agentId':alSettings.citiesId.toString(),'categoryId':category.id.toString()};
        if(searchController.text.trim().isNotEmpty)
        {
          bodyData.addAll({'search':searchController.text.trim()});
        }
        if(await repositories.store_search(bodyData:bodyData))
        {
          var data = json.decode(json.decode(repositories.message.data));
          List<Product> listOffProduct=dataProductFromJson(json.encode(data).toString());
          if(listOffProduct.isEmpty)
            {
              empty=true;
              refreshController.loadNoData();
            }
          else
            {
              product.addAll(listOffProduct);
              update();
              refreshController.loadComplete();
              page++;
            }
        }
        else
        {
          refreshController.loadFailed();
        }
      }
      catch(e) {
        refreshController.loadFailed();
      }
    }
  }

  @override
  void onInit() {
    FlutterStatusbarcolor.setNavigationBarColor(AppColors.whiteColor);
    getStore();
    // TODO: implement onInit
    super.onInit();
  }


}