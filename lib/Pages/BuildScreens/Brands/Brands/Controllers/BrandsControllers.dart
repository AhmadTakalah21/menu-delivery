


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/Model/Model/BrandModel.dart';
import 'package:shopping_land_delivery/Model/Model/Types.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/Brands/Repositories/BrandsRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class BrandsControllers extends GetxController
{
  RxInt pageState=1.obs;
  RxInt pageStateProduct=0.obs;
  RxString title=''.obs;
  RxInt pageStateSearch=1.obs;
  RxInt pageSearch=1.obs;
  RxBool isGetTypes=false.obs;
  TextEditingController searchController=TextEditingController();
  RxBool isClear= false.obs;
  RxBool isSearch = false.obs;
  FocusNode focusNode = FocusNode();
  RxBool showSearch = false.obs;
  RxBool pageSearchBool=false.obs;
  RxString brandId=''.obs;

  late ValueNotifier<TextDirection> textDir ;

  RxList<Types> type =<Types>[].obs;
  RxList<BrandModel> brands =<BrandModel>[].obs;
  RxList<BrandModel> brandsSearch =<BrandModel>[].obs;

  late RefreshController refreshController ;
  int page =2;
  bool empty =false;
  RxBool isGetListOfLoading =false.obs;

  BrandsControllers(){
    textDir = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);
    refreshController= RefreshController(initialRefresh: false);

  }



  Future<void> display_types() async{
    isGetTypes.value=false;
    BrandsRepositories repositories  =BrandsRepositories();
    if(await repositories.display_types())
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        type.value =dataTypesFromJson(json.encode(data['types']).toString());
        brandId.value=type.value.first.id.toString();
      }


      await display_brands();
      pageStateProduct.value=1;
      isGetTypes.value=true;
    }
    else
    {
      pageState.value=2;
    }
  }


  Future<void> display_brands() async{
    isGetTypes.value=false;
    BrandsRepositories repositories  =BrandsRepositories();
    if(await repositories.display_brands(bodyData: {'perPage':'10','city_id':alSettings.citiesId.value,'type_id':brandId.value.toString()}))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        brands.value =dataBrandModelFromJson(json.encode(data['brands']).toString());
      }
    }
    else
    {
      pageState.value=2;
    }
  }




  Future<void> filterProduct()async {
    BrandsRepositories repositories  =BrandsRepositories();
    pageStateSearch.value=0;
    pageStateProduct.value=0;
    page=2;

    Map<String, String> body ={
      'perPage':'10',
      'city_id':alSettings.citiesId.value,
      'type_id':brandId.value.toString()
    };
    if(searchController.text.trim().isNotEmpty)
    {
      body.addAll({'search':searchController.text.trim(),});
    }

    if(await repositories.search_by_brand(bodyData:body))
    {
      RxList<BrandModel> dataList =<BrandModel>[].obs;

      if(repositories.message.data!=null)
      {
        var data =  repositories.message.data==null?null :json.decode(json.decode(repositories.message.data));
        dataList.value =data!=null ?dataBrandModelFromJson(json.encode(data['data']).toString()):[];
      }
      if(searchController.text.trim().isNotEmpty)
        {
          brandsSearch=dataList;
        }
      else
        {
          brands=dataList;
        }
      update();
      pageStateSearch.value=1;
      pageStateProduct.value=1;

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
      BrandsRepositories repositories  =BrandsRepositories();
      Map<String, String> body ={
        'perPage':'10',
        'city_id':alSettings.citiesId.value,
        'type_id':brandId.value.toString()
      };
      RxList<BrandModel> dataList =<BrandModel>[].obs;
      if(await repositories.search_by_brand(bodyData: body))
      {
        if(repositories.message.data!=null)
        {
          var data =  repositories.message.data==null?null :json.decode(json.decode(repositories.message.data));
          dataList.value =data!=null ?dataBrandModelFromJson(json.encode(data['data']).toString()):[];
        }
        if(searchController.text.trim().isNotEmpty)
        {
          brandsSearch=dataList;
        }
        else
        {
          brands=dataList;
        }
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
    update();
    if(empty)
    {
      title.value=TranslationKeys.noMore.tr;
    }
    else
    {
      try{

        BrandsRepositories repositories  =BrandsRepositories();
        Map<String, String> body ={
          'perPage':'10',
          'city_id':alSettings.citiesId.value,
          'type_id':brandId.value.toString(),
          'page':page.toString()
        };
        RxList<BrandModel> dataList =<BrandModel>[].obs;
        if(await repositories.search_by_brand(bodyData: body))
        {
          if(repositories.message.data!=null)
          {
            page++;
            if(repositories.message.data!=null)
            {
              var data =  repositories.message.data==null?null :json.decode(json.decode(repositories.message.data));
              dataList.value =data!=null ?dataBrandModelFromJson(json.encode(data['data']).toString()):[];
            }
            if(searchController.text.trim().isNotEmpty)
            {
              brandsSearch.addAll(dataList);
            }
            else
            {
              brands.addAll(dataList);
            }

          }
          else
            {
              empty=true;
              title.value=TranslationKeys.noMore.tr;
            }
          refreshController.loadComplete();

        }
        else
        {
          refreshController.loadComplete();
        }

      }
      catch(e) {
        refreshController.loadFailed();
        update();
      }
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    display_types();

  }


}