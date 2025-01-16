

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/Model/Model/Advertisements.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Model/Model/Post.dart';
import 'package:shopping_land_delivery/Model/Model/Types.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Repositories/HomeRepositories.dart';
import 'package:shopping_land_delivery/main.dart';

class HomeController extends GetxController
{


  // RefreshController refreshController = RefreshController(initialRefresh: false);
  // RefreshController refreshController = RefreshController(initialRefresh: false);
  RxBool isChangeAgents=false.obs;

  bool empty =false;
  int page =2;
  RxInt pageState=1.obs;
  RxInt pageStateCategory=0.obs;
  RxInt pageStateSearch=1.obs;
  RxInt pageSearch=1.obs;
  RxBool pageSearchBool=false.obs;
  RxBool isGetADV1=false.obs;
  RxBool isGetType=false.obs;
  RxBool isGetADV2=false.obs;
  RxBool isGetOptionWidget=false.obs;
  RxBool isGetPosts=false.obs;

  RxList<Advertisements> advertisements =<Advertisements>[].obs;
  RxList<Advertisements> advertisements2 =<Advertisements>[].obs;
  RxList<Category> category =<Category>[].obs;
  RxList<OptionWidget> optionWidget =<OptionWidget>[].obs;
  RxList<PostModel> post =<PostModel>[].obs;
  RxList<Types> type =<Types>[].obs;





  RxList<Category> categorySearch =<Category>[].obs;
  TextEditingController searchController=TextEditingController();
  RxBool showSearch = false.obs;
  RxBool isClear= false.obs;
  RxBool isSearch = false.obs;
  RxBool isClearSug = false.obs;
  FocusNode focusNode = FocusNode();
  RxString agentName = ''.obs;


  late ValueNotifier<TextDirection> textDir ;

  HomeController() {
    textDir = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);
  }

  Future<void> getAdv() async{
    HomeRepositories repositories  =HomeRepositories();
    if(await repositories.get_adv(body: {'for':'1','sort':'created_at'}))
      {
        if(repositories.message.data!=null)
          {
            var data = json.decode(json.decode(repositories.message.data));
            advertisements.value =dataAdvertisementsFromJson(json.encode(data['advertisments']).toString());
          }
        isGetADV1.value=true;
      }
    else
    {
      pageState.value=2;
    }
  }

  Future<void> getAdv2() async{
    HomeRepositories repositories  =HomeRepositories();
    if(await repositories.get_adv(body:  {'for':'2','sort':'created_at'}))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        advertisements2.value =dataAdvertisementsFromJson(json.encode(data['advertisments']).toString());
      }
      isGetADV2.value=true;
    }
    else
      {
        pageState.value=2;
      }

  }

  Future<void> display_types() async{
    pageState.value=1;
    pageStateCategory.value=0;
    HomeRepositories repositories  =HomeRepositories();
    if(await repositories.display_types())
    {
      if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          type.value =dataTypesFromJson(json.encode(data['types']).toString());
        }
      isGetType.value=true;
    }
    else
      {
        pageState.value=2;
      }
  }


  Future<void> display_active_slider() async{
    isGetOptionWidget.value=false;
    HomeRepositories repositories  =HomeRepositories();
    if(await repositories.display_active_slider())
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        optionWidget.value =dataOptionWidgetFromJson(json.encode(data['sliders']).toString());
      }
      isGetOptionWidget.value=true;
    }
    else
    {
      pageState.value=2;
    }
  }


  Future<void> display_posts() async{
    isGetPosts.value=false;
    HomeRepositories repositories  =HomeRepositories();
    if(await repositories.display_posts(bodyData: {'sort':'-created_at'}))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        post.value =dataPostFromJson(json.encode(data['posts']).toString());
      }
      isGetPosts.value=true;
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

  Future<void> like_or_unlike(PostModel item) async{
    HomeRepositories repositories  =HomeRepositories();
    await repositories.like_or_unlike(bodyData: {'post_id':item.id.toString()});

  }



  //
  // Future<void> getListOfRefresh()async{
  //   try{
  //     page=2;
  //     empty=false;
  //     HomeRepositories repositories  =HomeRepositories();
  //     if(await repositories.display_types())
  //       {
  //         var data = json.decode(json.decode(repositories.message.data));
  //         category.value =dataCategoryFromJson(json.encode(data).toString());
  //         try
  //         {
  //           MainScreenViewControllers controller = Get.find();
  //           controller.category=category;
  //         }
  //         catch(e){}
  //       refreshController.refreshCompleted();
  //     }
  //     else
  //     {
  //       refreshController.refreshFailed();
  //     }
  //   }
  //   catch(e) {
  //     refreshController.refreshFailed();
  //   }
  //
  // }
  //
  //
  //
  // Future<void> getListOfLoading()async{
  //   if(empty)
  //   {
  //     refreshController.loadNoData();
  //   }
  //   else
  //   {
  //     try{
  //       HomeRepositories repositories  =HomeRepositories();
  //
  //       Map<String, String> body ={
  //         'search':searchController.text.trim(),
  //         'page':page.toString(),
  //       };
  //
  //       if(await repositories.display_types(bodyData: searchController.text.trim().isNotEmpty?body:{'page':page.toString(),}))
  //       {
  //         RxList<Category> categoryNew =<Category>[].obs;
  //         if(repositories.message.data!=null)
  //         {
  //           var data = json.decode(json.decode(repositories.message.data));
  //           categoryNew.value =dataCategoryFromJson(json.encode(data));
  //         }
  //         if(categoryNew.isEmpty)
  //         {
  //           empty=true;
  //           refreshController.loadNoData();
  //         }
  //         else
  //         {
  //           if(searchController.text.trim().isNotEmpty)
  //             {
  //               categorySearch.addAll(categoryNew);
  //             }
  //           else
  //             {
  //               category.addAll(categoryNew);
  //             }
  //           refreshController.loadComplete();
  //           update();
  //           page++;
  //         }
  //       }
  //       else
  //       {
  //         refreshController.loadFailed();
  //       }
  //     }
  //     catch(e) {
  //       refreshController.loadFailed();
  //     }
  //   }
  // }


  @override
  void onInit() {
    // TODO: implement onInit
    isGetADV1=false.obs;
    isGetType=false.obs;
    isGetADV2=false.obs;
    isGetOptionWidget=false.obs;
    isGetPosts=false.obs;
    getAdv();
    getAdv2();
    display_types();
    display_active_slider();
    display_posts();

    // refreshController = RefreshController(initialRefresh: false);
    super.onInit();
  }
}