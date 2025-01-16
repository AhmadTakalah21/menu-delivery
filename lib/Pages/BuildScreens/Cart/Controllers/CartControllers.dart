

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/packages/rounded_loading_button-2.1.0/rounded_loading_button.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/Model/Model/CartModel.dart';
import 'package:shopping_land_delivery/Model/Model/Category.dart';
import 'package:shopping_land_delivery/Model/Model/Cities.dart';
import 'package:shopping_land_delivery/Model/Model/DeliveryTypes.dart';
import 'package:shopping_land_delivery/Model/Model/Discount.dart';
import 'package:shopping_land_delivery/Model/Model/MethodTypes.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Repositories/CartRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class CartControllers extends GetxController
{
  RxInt pageState=1.obs;
  RxInt pageStateCart=0.obs;
   GlobalKey<FormState> form = GlobalKey<FormState>();

  RoundedLoadingButtonController btnController =  RoundedLoadingButtonController();
  RoundedLoadingButtonController btnController2 =  RoundedLoadingButtonController();
  RoundedLoadingButtonController btnController3 =  RoundedLoadingButtonController();
  TextEditingController code= TextEditingController(text: '');


  TextEditingController name= TextEditingController(text: '');
  TextEditingController name2= TextEditingController(text: '');
  TextEditingController phone= TextEditingController(text: '');
  TextEditingController address= TextEditingController(text: '');




  CartRepositories repositories  =CartRepositories();



  RxString methodTypesName =''.obs;
  RxString methodTypesId=''.obs;



  RxString deliveryTypesName =''.obs;
  RxString deliveryTypesId=''.obs;


  RxString discountName =''.obs;
  RxString discountId=''.obs;

  RxBool isCheckDiscount=false.obs;
  RxBool isCheckDiscountEnd=false.obs;


  RxList<CartModel> carts =<CartModel>[].obs;
  RxList<MethodTypes> methodTypes =<MethodTypes>[].obs;
  RxList<DeliveryTypes> deliveryTypes =<DeliveryTypes>[].obs;
  RxList<Discount> discount =<Discount>[].obs;


  Future<void> display_carts() async{
    try
    {
      pageState.value=1;
      pageStateCart.value=0;

      if(await repositories.display_carts() )
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          carts.value =dataCartModelFromJson(json.encode([data]));
          if(carts.isNotEmpty)
            {
              if(await repositories.display_payment_method() )
              {
                if(repositories.message.data!=null)
                {
                  var data = json.decode(json.decode(repositories.message.data));
                  methodTypes.value =dataMethodTypesFromJson(json.encode(data['paymentMethods']['data']));
                  methodTypesName.value=TranslationKeys.select.tr;
                }
                if(await repositories.display_delivery_types() )
                {
                  if(repositories.message.data!=null)
                  {
                    var data = json.decode(json.decode(repositories.message.data));
                    deliveryTypes.value =dataDeliveryTypesFromJson(json.encode(data['deliveryTypes']['data']));
                    deliveryTypesName.value=TranslationKeys.select.tr;
                  }
                  pageStateCart.value=1;
                }
                else
                {
                  pageState.value=2;
                }
              }
              else
              {
                pageState.value=2;
              }
            }

        }
        pageStateCart.value=1;

      }
      else
      {
        pageState.value=2;
      }
    }
    catch(e)
    {
      print(e);
      pageState.value=2;
    }

  }



  Future<void> check_coupon() async{
    try
    {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      discount.clear();
      if(Platform.isIOS)
      {
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native);
      }
      SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);

      SVProgressHUD.show(status: 'تحقق');
      Map<String,String> body ={
        'code':code.text.trim().toString(),
      };
      if(await repositories.check_coupon(body: body) )
      {
        SVProgressHUD.showSuccess(status: 'تم');
        var data = json.decode(json.decode(repositories.message.data));
        double percentageValue = (data['percent'] / 100) * carts.first.totalPriceAfterDiscount;
        // Subtract the percentage value from the original number
        double result = carts.first.totalPriceAfterDiscount! - percentageValue;
        discount.add(Discount(amount: data['percent'],percent:result.toInt() ));
        SVProgressHUD.dismiss();
      }
      else
        {
          SVProgressHUD.showError(status: 'لم يتم العثور على نسبة حسم مرتبطة بالكود');
          await Future.delayed(Duration(seconds: 2));
          SVProgressHUD.dismiss();
        }

    }
    catch(e)
    {
      SVProgressHUD.dismiss();
      print(e);
    }

  }




  Future<void> addOrder() async{

    try
    {
      Map<String,String> body ={
     'last_name':name2.text.trim(),
     'delivery_type_id':deliveryTypesId.value.trim(),
    'payment_method_id':methodTypesId.value.trim(),
    'address':address.text.trim(),
    'first_name':name.text.trim(),
    'phone':phone.text.trim(),
    'city_id':alSettings.currentUser!.citiesId.toString()
      };
      if(discount.isNotEmpty)
        {
        body.addAll({'coupon':code.text.trim()});
        }
      if(await repositories.add_order(body: body))
      {
        btnController.success();
        Timer(const Duration(seconds: 1), () {
          Get.back();
          onInit();
        },

        );
      }
      else
      {
        btnController.error();
        ALMethode.showToast(
            title: TranslationKeys.somethingWentWrong.tr,
            message: repositories.message.description??TranslationKeys.errorEmail.tr,
            type: ToastType.error, context: Get.context!);
        Timer(
          const Duration(seconds: 1),
              () {
            btnController.reset();
          },
        );
      }
    }
    catch(e)
    {
      SVProgressHUD.dismiss();
      print(e);
    }

  }






  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    display_carts();

  }
}
