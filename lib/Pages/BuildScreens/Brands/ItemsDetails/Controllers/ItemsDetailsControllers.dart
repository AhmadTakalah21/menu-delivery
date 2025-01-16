



import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shopping_land_delivery/Services/helper/status_bar.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/Model/Model/BrandModel.dart';
import 'package:shopping_land_delivery/Model/Model/ItemStore.dart';
import 'package:shopping_land_delivery/Model/Model/ItemsDetailsModel.dart';
import 'package:shopping_land_delivery/Model/Model/MasterCategories.dart';
import 'package:shopping_land_delivery/Model/Model/OptionWidget.dart';
import 'package:shopping_land_delivery/Model/Model/Product.dart';
import 'package:shopping_land_delivery/Model/Model/SubCategories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/ItemsDetails/Repositories/ItemsDetailsRepositories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/Home/Repositories/HomeRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class ItemsDetailsControllers extends GetxController {

  late Items itemsView;
  Color? color;
  bool offer=false;
  RxInt pageStateProduct=0.obs;
  RxInt pageState=1.obs;
  Rx<ItemStore> itemStore =ItemStore().obs;
  TextEditingController controller =TextEditingController(text:'1');
  RoundedLoadingButtonController btnController =  RoundedLoadingButtonController();

  RxInt pageStateSearch=1.obs;
  RxInt pageSearch=1.obs;
  RxBool isGetTypes=false.obs;
  RxBool pageSearchBool=false.obs;


  RxList<MasterCategories> masterCategories =<MasterCategories>[].obs;
  RxList<SubCategories> subCategories =<SubCategories>[].obs;
  RxList<ItemsDetailsModel> item =<ItemsDetailsModel>[].obs;
  TextEditingController quantityTextE= TextEditingController(text: '1');
  RxList<Measurements> measurements=<Measurements>[].obs;
  late ValueNotifier<TextDirection> textDir ;
  late RefreshController refreshController ;
  ItemsDetailsControllers(){
    itemsView=Get.arguments;
    textDir = ValueNotifier(alSettings.currentUser!=null && alSettings.currentUser!.locale!='ar' ?TextDirection.ltr : TextDirection.rtl);
    refreshController= RefreshController(initialRefresh: false);
  }


  Future<void> add_item_or_cancel_favourite(String id) async{
    HomeRepositories repositories  =HomeRepositories();
    await repositories.add_item_or_cancel_favourite(bodyData: {'item_id':id.toString()});
  }



  Future<void> add_item_to_cart() async{
    if(Platform.isIOS)
    {
      SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native);
    }
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);

    SVProgressHUD.show(status: 'اضافة');
    ItemsDetailsRepositories repositories  =ItemsDetailsRepositories();


    FormData form = createFormData(json.decode(json.encode(measurements)));
    form.fields.add(MapEntry('quantity',quantityTextE.text.trim().toString()));
    form.fields.add(MapEntry('item_id',item.first.id.toString()));


    if(await repositories.add_item_to_cart(bodyData: form))
    {

      SVProgressHUD.showSuccess(status: 'تم');
      await Future.delayed(Duration(seconds: 1));
      SVProgressHUD.dismiss();
      Get.back();
    }
    else
    {
      SVProgressHUD.dismiss();
      ALMethode.showToast(
          title: TranslationKeys.somethingWentWrong.tr,
          message: repositories.message.description??TranslationKeys.errorEmail.tr,
          type: ToastType.error, context: Get.context!);
    }
  }


  Future<void> display_items() async{
    isGetTypes.value=false;
    ItemsDetailsRepositories repositories  =ItemsDetailsRepositories();

    Map<String,String> body = {'city_id':alSettings.citiesId.value,'item_id':itemsView.id.toString(),};
    if(await repositories.display_item_by_id(bodyData: body))
    {
      if(repositories.message.data!=null)
      {
        var data = json.decode(json.decode(repositories.message.data));
        item.value =dataItemsDetailsModelFromJson([json.encode(data)].toString().toString());

        if(item.first.units!=null && item.first.units!.isNotEmpty)
          {
            item.first.units!.forEach((element) {
              measurements.add(element.measurements!.first);
            });

          }

        if(item.first.images!=null)
          {
             color =  await ALMethode.getDominantColor(item.first.images!.first.url.toString());
            await FlutterStatusbarcolor.setNavigationBarColor(color!);
            await FlutterStatusbarcolor.setStatusBarColor(color!);

          }

      }
      isGetTypes.value=true;
    }
    else
    {
      pageState.value=2;
    }
  }




   FormData createFormData(List<dynamic> percents) {
    FormData formData = FormData({});
    for (int i = 0; i < percents.length; i++) {
      formData.fields.add(MapEntry('item_measurements[$i][measurement_id]', percents[i]['id'].toString()));
    }

    return formData;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // showItemStoreOffers();
    display_items();
  }

}