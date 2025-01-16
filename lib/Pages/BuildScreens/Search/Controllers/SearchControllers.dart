



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';
import 'package:shopping_land_delivery/Model/Model/Product.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/CategoryDetails/Repositories/CategoryDetailsRepositories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Repositories/HomeRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class SearchControllers extends GetxController
{
  RxInt pageState=1.obs;
  RxInt pageStateProduct=0.obs;
  RxInt pageStateSearch=1.obs;
  RxInt pageSearch=1.obs;
  RxBool pageSearchBool=false.obs;
  RxString categoryName='all'.obs;
  RxString categoryId='all'.obs;
  RxList<Category> category =<Category>[].obs;
  RxList<String> categoryNameS =<String>[].obs;
  RxList<Product> product =<Product>[].obs;
  GlobalKey<SmartRefresherState> refreshKey = GlobalKey<SmartRefresherState>();

  RxList<Product> productSearch =<Product>[].obs;
  TextEditingController searchController=TextEditingController();
  late RefreshController refreshController ;
  bool empty =false;
  int page =2;
  RxBool showSearch = false.obs;
  RxBool status = false.obs;
  RxBool isClear= false.obs;
  RxBool isSearch = false.obs;
  RxBool isClearSug = false.obs;
  FocusNode focusNode = FocusNode();

  late ValueNotifier<TextDirection> textDir ;

  SearchControllers() {
    textDir = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);
    refreshController= RefreshController(initialRefresh: false);
    Future.delayed(Duration(seconds: 4),(){
      if(category.isEmpty)
      {
        getCategories();
      }
      else
        {
          categoryNameS.value=category.value.map((element) => element.name.toString()).toList();
          categoryNameS.insert(0,TranslationKeys.all.tr);
        }
    });
  }

  Future<void> getCategories() async{
    HomeRepositories repositories  =HomeRepositories();
    if(await repositories.display_types())
    {
      var data = json.decode(json.decode(repositories.message.data));
      category.value =dataCategoryFromJson(json.encode(data).toString());
      categoryNameS.value=category.value.map((element) => element.name.toString()).toList();
      categoryNameS.insert(0,TranslationKeys.all.tr);
    }
  }

  Future<void> getStore() async{
    page=2;
    pageStateProduct.value=0;
    pageState.value=1;
    CategoryDetailsRepositories repositories  =CategoryDetailsRepositories();

    Map<String,String> bodyData ={'agentId':alSettings.citiesId.toString(),};

    if(await repositories.store_search(bodyData:bodyData))
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

    Map<String, String> body ={
      'type':status.value?'offers':'all',
      'agentId':alSettings.citiesId.toString()
    };
    if(searchController.text.trim().isNotEmpty)
      {
        body.addAll({'search':searchController.text.trim(),});
      }
    if(categoryId.value!='all')
      {
        body.addAll({'categoryId':categoryId.value,});
      }
    if(await repositories.store_search(bodyData:body))
    {

      if(repositories.message.data!=null)
      {
        var data =  repositories.message.data==null?null :json.decode(json.decode(repositories.message.data));
        productSearch.value =data!=null ?dataProductFromJson(json.encode(data).toString()):[];
      }
      else
        {
          productSearch.value=[];
        }
      update();
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

      Map<String, String> body ={
        'type':status.value?'offer':'all',
        'agentId':alSettings.citiesId.toString()
      };
      if(searchController.text.trim().isNotEmpty)
      {
        body.addAll({'search':searchController.text.trim(),});
      }
      if(categoryId.value!='all')
      {
        body.addAll({'categoryId':categoryId.value,});
      }
      if(await repositories.store_search(bodyData: body))
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

    }
    else
    {
      try{
        CategoryDetailsRepositories repositories  =CategoryDetailsRepositories();

        Map<String, String> body ={
          'type':status.value?'offers':'all',
          'page':page.toString(),
          'agentId':alSettings.citiesId.toString()
        };
        if(searchController.text.trim().isNotEmpty)
        {
          body.addAll({'search':searchController.text.trim(),});
        }
        if(categoryId.value!='all')
        {
          body.addAll({'categoryId':categoryId.value,});
        }
        if(await repositories.store_search(bodyData:body))
        {
          List<Product> listOffProduct =[];
          if(repositories.message.data!=null)
            {
              var data = json.decode(json.decode(repositories.message.data));
              listOffProduct = listOffProduct=dataProductFromJson(json.encode(data).toString());
            }
          if(listOffProduct.isEmpty)
          {
            empty=true;
          }
          else
          {
            product.addAll(listOffProduct);
            refreshController.loadComplete();
            update();
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
    // TODO: implement onInit
    super.onInit();
    getStore();
    categoryId.listen((p0) {
      filterProduct();
    });
  }

}