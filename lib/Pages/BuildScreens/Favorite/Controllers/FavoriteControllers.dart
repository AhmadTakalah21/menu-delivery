







import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Model/Model/Types.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Favorite/Repositories/FavoriteRepositories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Repositories/HomeRepositories.dart';

class FavoriteControllers extends GetxController
{
  RxBool isGetFavourites=false.obs;

  late ValueNotifier<TextDirection> textDir ;
  RxInt pageState=1.obs;
  RxList<Types> type =<Types>[].obs;

  RxList<Items> optionWidget =<Items>[].obs;
  RxList<Items> optionWidgetSearch =<Items>[].obs;

   RefreshController refreshController = RefreshController(initialRefresh: false);
  int page =2;
  bool empty =false;
  RxBool isGetListOfLoading =false.obs;





  Future<void> display_favourites() async{
    isGetFavourites.value=false;
    FavoriteRepositories repositories  =FavoriteRepositories();
    if(await repositories.display_favourites(bodyData: {'perPage':'10','page':'1'}))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        optionWidget.value =dataItemsWidgetFromJson(json.encode(data['items']).toString());
      }

      isGetFavourites.value=true;
    }
    else
    {
      pageState.value=2;
    }
  }



  

  
  Future<void> getListOfRefresh()async{
    try{
      page=2;
      FavoriteRepositories repositories  =FavoriteRepositories();
      if(await repositories.display_favourites(bodyData: {'perPage':'10','page':'1'}))
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          optionWidget.value =dataItemsWidgetFromJson(json.encode(data['items']).toString());

          refreshController.refreshCompleted();
        }
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

      try{

        FavoriteRepositories repositories  =FavoriteRepositories();
        if(await repositories.display_favourites(bodyData: {'perPage':'10','page':page.toString(),}))
        {
          if(repositories.message.data!=null)
          {
            var data = json.decode(json.decode(repositories.message.data));
            print(data);
            optionWidget.value.addAll(dataItemsWidgetFromJson(json.encode(data['items']).toString()));
            page++;
          }
          refreshController.loadComplete();
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

  Future<void> add_item_or_cancel_favourite(Items item) async{
    HomeRepositories repositories  =HomeRepositories();
    await repositories.add_item_or_cancel_favourite(bodyData: {'item_id':item.id.toString()});
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    display_favourites();

  }


}