

import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/Model/Model/NotificationsModel.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Notifications/Repositories/NotificationsRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';

class NotificationsControllers extends GetxController
{
  RxInt pageState=1.obs;
  RxInt pageStateProduct=1.obs;
  RxString title=''.obs;

  RxList<NotificationsModel> notifications =<NotificationsModel>[].obs;
  late RefreshController refreshController ;
  int page =2;
  bool empty =false;
  RxBool isGetListOfLoading =false.obs;




  NotificationsControllers(){
    refreshController= RefreshController(initialRefresh: false);

  }
  

  Future<void> show_notifications() async{
    try
    {
      pageState.value=1;
      pageStateProduct.value=0;
      NotificationsRepositories repositories  =NotificationsRepositories();
      if(await repositories.show_notifications())
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          notifications.value =dataNotificationsModelFromJson(json.encode(data));
        }
        pageStateProduct.value=1;

      }
      else
      {
        pageState.value=2;
      }
    }
    catch(e)
    {
      pageState.value=2;
    }
  }


  Future<void> getListOfRefresh()async{
    try{
      page=2;
      NotificationsRepositories repositories  =NotificationsRepositories();
      if(await repositories.show_notifications())
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          notifications.value =dataNotificationsModelFromJson(json.encode(data));
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
    update();
    if(empty)
    {
      title.value=TranslationKeys.noMore.tr;
    }
    else
    {
      try{
        isGetListOfLoading.value=true;
        NotificationsRepositories repositories  =NotificationsRepositories();
        if(await repositories.show_notifications(body: {'page':page.toString(),}))
        {
          if(repositories.message.data!=null)
          {
            var data = json.decode(json.decode(repositories.message.data));
            notifications.value.addAll(dataNotificationsModelFromJson(json.encode(data)));
            page++;
          }
          else
          {
            empty=true;
            title.value=TranslationKeys.noMore.tr;
          }
          isGetListOfLoading.value=false;
        }
        else
        {
          isGetListOfLoading.value=false;
        }
        update();
      }
      catch(e) {
        isGetListOfLoading.value=false;
        update();
      }
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // show_notifications();
  }


}