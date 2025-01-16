


import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/Model/Model/Percents.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Products/Repositories/ProductsRepositories.dart';
import 'package:shopping_land_delivery/main.dart';

class ProductsControllers extends GetxController
{



  RefreshController refreshController = RefreshController(initialRefresh: false);
  RxInt pageState=1.obs;
  RxInt pageStatePercents=0.obs;
  RxInt pageStateSearch=1.obs;
  RxList<Percents> percents =<Percents>[].obs;
  RxList<Percents> percentsSearch =<Percents>[].obs;
  List<Percents> pe =[];
  RoundedLoadingButtonController btnController =  RoundedLoadingButtonController();
  bool empty =false;
  int page =2;
  RxBool pageSearchBool=false.obs;
  TextEditingController searchController=TextEditingController();
  RxBool showSearch = false.obs;
  RxBool isClear= false.obs;
  RxBool isSearch = false.obs;
  RxBool isClearSug = false.obs;
  FocusNode focusNode = FocusNode();

  late ValueNotifier<TextDirection> textDir  = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);

  Future<void> show_percents() async{
    pageState.value=0;
    ProductsRepositories repositories  =ProductsRepositories();
    if(await repositories.show_percents())
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        percents.value =dataPercentsFromJson(json.encode(data).toString());
      }
      pageState.value=1;
    }
    else
    {
      pageState.value=2;
    }
  }



  Future<void> filterPercents()async {
    ProductsRepositories repositories  =ProductsRepositories();
    pageStateSearch.value=0;
    if(await repositories.show_percents(body: {'search':searchController.text.trim()}))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        percentsSearch.value =dataPercentsFromJson(json.encode(data).toString());
      }
      pageStateSearch.value=1;
      pageSearchBool.value=false;
    }
  }


  Future<void> add_percents() async{
    if(pe.isEmpty)
    {
      btnController.reset();
    }
    else
    {
      ProductsRepositories repositories  =ProductsRepositories();
      if(await repositories.add_percents(body:createFormData(json.decode(json.encode(pe)))))
      {
        btnController.success();
        pe.clear();
        await Future.delayed(const Duration(seconds: 1));
        onInit();
      }
      else
      {
        btnController.error();
        await Future.delayed(const Duration(seconds: 1));
        btnController.reset();

      }
    }

  }


  onChanged({required int price,required Percents percents})
  {
    if(pe.isEmpty)
    {
      if(price>0)
      {
        pe.add(Percents(itemId: percents.itemId,percent:price ));
      }
    }
    else
    {
      int index =pe.indexWhere((element) => element.itemId==percents.itemId);
      if(index!=-1)
      {
        pe[index].percent=price;
      }
      else
      {
        pe.add(Percents(itemId: percents.itemId,percent:price));
      }
    }






  }


  Future<void> getListOfRefresh()async{
    try{
      page=2;
      empty=false;
      ProductsRepositories repositories  =ProductsRepositories();
      if(await repositories.show_percents(body: {'user':'MUser',}))
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          percents.value =dataPercentsFromJson(json.encode(data));
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
    if(empty)
    {
      refreshController.loadNoData();
    }
    else
    {
      try{
        ProductsRepositories repositories  =ProductsRepositories();

        Map<String, String> body ={
          'user':'MUser',
          'page':page.toString(),
        };
        if(searchController.text.trim().isNotEmpty)
          {
            body.addAll({'search':searchController.text.trim()});
          }
        if(await repositories.show_percents(body: body))
        {
          RxList<Percents> orderHistoryNew =<Percents>[].obs;

          if(repositories.message.data!=null)
          {
            var data = json.decode(json.decode(repositories.message.data));
            orderHistoryNew.value =dataPercentsFromJson(json.encode(data));
          }
          if(orderHistoryNew.isEmpty)
          {
            empty=true;
            refreshController.loadNoData();
          }
          else
          {
            if(searchController.text.trim().isNotEmpty)
              {
                percentsSearch.addAll(orderHistoryNew);
              }
            else{
              percents.addAll(orderHistoryNew);

            }
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
    show_percents();

  }


  static FormData createFormData(List<dynamic> percents) {
    FormData formData = FormData({});
    for (int i = 0; i < percents.length; i++) {
      formData.fields.add(MapEntry('percents[$i][item_id]', percents[i]['item_id'].toString()));
      formData.fields.add(MapEntry('percents[$i][percent]', percents[i]['percent'].toString()));
    }

    return formData;
  }

}