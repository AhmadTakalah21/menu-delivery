



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/Model/Model/BrandModel.dart';
import 'package:shopping_land_delivery/Model/Model/ItemStore.dart';
import 'package:shopping_land_delivery/Model/Model/MasterCategories.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Model/Model/Product.dart';
import 'package:shopping_land_delivery/Model/Model/SubCategories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/BrandsDetails/Repositories/BrandsDetailsRepositories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Repositories/HomeRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class BrandsDetailsControllers extends GetxController {

  late BrandModel brand;
  bool offer=false;
  RxInt pageStateProduct=0.obs;
  RxInt pageState=1.obs;
  Rx<ItemStore> itemStore =ItemStore().obs;
  TextEditingController controller =TextEditingController(text:'1');
  RoundedLoadingButtonController btnController =  RoundedLoadingButtonController();
  int page =2;
  bool empty =false;
  RxString title=''.obs;
  RxInt pageStateSearch=1.obs;
  RxInt pageSearch=1.obs;
  RxBool isGetTypes=false.obs;
  RxBool isGetItems=false.obs;
  RxBool isGetSub=false.obs;
  TextEditingController searchController=TextEditingController();
  RxBool isClear= false.obs;
  RxBool isSearch = false.obs;
  FocusNode focusNode = FocusNode();
  RxBool showSearch = false.obs;
  RxBool pageSearchBool=false.obs;
  RxString masterId=''.obs;
  RxString subId=''.obs;

  RxList<MasterCategories> masterCategories =<MasterCategories>[].obs;
  RxList<SubCategories> subCategories =<SubCategories>[].obs;
  RxList<Items> optionWidget =<Items>[].obs;
  RxList<Items> optionWidgetSearch =<Items>[].obs;
  late ValueNotifier<TextDirection> textDir ;
  late RefreshController refreshController ;
  BrandsDetailsControllers(){
    brand=Get.arguments;
    textDir = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);
    refreshController= RefreshController(initialRefresh: false);
  }


  // Future<void> showItemStoreOffers() async{
  //   pageStateProduct.value=0;
  //   pageState.value=1;
  //   BrandsDetailsRepositories repositories  =BrandsDetailsRepositories();
  //   if(await repositories.show_offer(bodyData: {'offerId':items.offerId.toString(),'agentId':alSettings.citiesId.toString()}))
  //   {
  //     var data = json.decode(repositories.message.data);
  //     itemStore.value =dataItemStoreFromJson([data].toString()).first;
  //     pageStateProduct.value=1;
  //   }
  //   else
  //   {
  //     pageState.value=2;
  //   }
  // }


  Future<void> display_master_categories() async{
    isGetTypes.value=false;
    isGetItems.value=false;

    BrandsDetailsRepositories repositories  =BrandsDetailsRepositories();
    if(await repositories.display_master_categories(bodyData: {'city_id':alSettings.citiesId.value,'brand_id':brand.id.toString()}))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        masterCategories.value =dataMasterCategoriesModelFromJson(json.encode(data['master_categories']).toString());
        masterId.value=masterCategories.first.id.toString();
        isGetItems.value=true;
        if(masterCategories.first.isSub==1)
          {
            await display_sub_categories();
          }
        else
          {
            isGetSub.value=true;
            await display_items();
          }

        isGetTypes.value=true;
      }
    }
    else
    {
      pageState.value=2;
    }
  }


  Future<void> display_sub_categories() async{
    isGetSub.value=false;
    pageStateSearch.value=0;
    pageStateProduct.value=0;
    BrandsDetailsRepositories repositories  =BrandsDetailsRepositories();
    if(await repositories.display_sub_categories(bodyData: {'city_id':alSettings.citiesId.value,'brand_id':brand.id.toString(),'master_id':masterId.value}))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        subCategories.value =dataSubCategoriesModelFromJson(json.encode(data['sub_categories']).toString());
        if(subCategories.isNotEmpty)
          {
            subId.value=subCategories.first.id.toString();
          }
        else
          {
            subId.value='';
          }
        isGetSub.value=true;
        await display_items();
        pageStateSearch.value=1;
        pageStateProduct.value=1;
      }
    }
    else
    {
      pageState.value=2;
    }
  }

  Future<void> add_item_or_cancel_favourite(Items item) async{
    HomeRepositories repositories  =HomeRepositories();
    await repositories.add_item_or_cancel_favourite(bodyData: {'item_id':item.id.toString()});
  }

  Future<void> display_items() async{
    pageStateSearch.value=0;
    pageStateProduct.value=0;
    BrandsDetailsRepositories repositories  =BrandsDetailsRepositories();

    Map<String,String> body = {'perPage':'10','page':'1','city_id':alSettings.citiesId.value,'brand_id':brand.id.toString(),'master_id':masterId.value,};
    if(subId.value.toString().isNotEmpty)
      {
        body.addAll({'sub_id':subId.value.toString()});
      }
    if(await repositories.display_items(bodyData: body))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        optionWidget.value =dataItemsWidgetFromJson(json.encode(data['items']).toString());
      }
      pageStateSearch.value=1;
      pageStateProduct.value=1;
    }
    else
    {
      pageState.value=2;
    }
  }

  Future<void> getListOfRefresh()async{
    try{
      page=2;
      BrandsDetailsRepositories repositories  =BrandsDetailsRepositories();
      Map<String,String> body = {'perPage':'10','page':'1','city_id':alSettings.citiesId.value,'brand_id':brand.id.toString(),'master_id':masterId.value,};

      if(subId.value.toString().isNotEmpty)
      {
        body.addAll({'sub_id':subId.value.toString()});
      }
      if(searchController.text.trim().isNotEmpty)
      {
        body.addAll({'search':searchController.text.trim().toString()});
      }
      RxList<Items> dataList =<Items>[].obs;
      if(await repositories.display_items(bodyData: body))
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          dataList.value =dataItemsWidgetFromJson(json.encode(data['items']).toString());
        }
        if(searchController.text.trim().isNotEmpty)
        {
          optionWidgetSearch=dataList;
        }
        else
        {
          optionWidget=dataList;
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

        BrandsDetailsRepositories repositories  =BrandsDetailsRepositories();
        Map<String,String> body = {'perPage':'10','page':page.toString(),'city_id':alSettings.citiesId.value,'brand_id':brand.id.toString(),'master_id':masterId.value,};

        if(subId.value.toString().isNotEmpty)
        {
          body.addAll({'sub_id':subId.value.toString()});
        }
        if(searchController.text.trim().isNotEmpty)
        {
          body.addAll({'search':searchController.text.trim().toString()});
        }
        RxList<Items> dataList =<Items>[].obs;
        if(await repositories.display_items(bodyData: body))
        {
          if(repositories.message.data!=null)
          {
            page++;
            if(repositories.message.data!=null)
            {
              var data =  repositories.message.data==null?null :json.decode(json.decode(repositories.message.data));
              dataList.value =data!=null ?dataItemsWidgetFromJson(json.encode(data['items']).toString()):[];
            }
            if(searchController.text.trim().isNotEmpty)
            {
              optionWidgetSearch.addAll(dataList);
            }
            else
            {
              optionWidget.addAll(dataList);
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
    // showItemStoreOffers();
    display_master_categories();
  }

}