

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' ;
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/Configuration/config.dart';
import 'package:shopping_land_delivery/Model/Model/CurrentUser.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';



class ALSettings extends GetxController with WidgetsBindingObserver
{

  RxBool isPage=false.obs;
  RxBool security=false.obs;
  RxBool scrollVisibility=false.obs;
  CurrentUser? currentUser;
  GlobalKey<ScaffoldState>? scaffoldKey;
  RxString routeName =''.obs;
  RxBool routeInThis =false.obs;
  RxBool rTL =true.obs;
 RxString citiesId=''.obs;
  RxBool routeInThisShowSlidingBottomSheet =false.obs;
  String currency='';



  ALSettings(){
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state==AppLifecycleState.resumed)
    {

      Future.delayed(Duration.zero,()async{
        security.value =await ALMethode.security();

        if(security.value)
        {
          security.value=true;
          SystemNavigator.pop();
        }
      });
    }

    // Handle other states if needed
  }


  Future<void> getUserInfo() async {

    List<String>? session = await ALMethode.getSharedPreferencesWithType(kay: 'session', type: SharedPreferencesType.listString);
    String? local = await ALMethode.getSharedPreferencesWithType(kay: 'locale', type: SharedPreferencesType.string);

    if(session!=null) {
      currentUser= CurrentUser(
              userId:session[0],
              email:session[1],
              password:session[2],
              fullName:session[3],
              apiKey:session[4],
              fcmToken:session[5],
              image:session[6],
             locale:local??session[7],
              userName:session[8],

          );
      if( session.length>9)
        {
          currentUser!.citiesId=session[9];
        }
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
   super.onInit();
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
   await Future.delayed(Duration.zero,() async{
      Future.delayed(Duration.zero,() async{
        security.value =await ALMethode.security();
        if(security.value)
          {
            SystemNavigator.pop();
          }
      });

         await getUserInfo();
         if(currentUser!=null && currentUser!.locale!=null)
         {
           if(currentUser!.locale!='ar')
           {
             rTL.value=false;
           }
           Get.updateLocale( Locale(currentUser!.locale!,''));
         }
         else
         {

           Get.updateLocale( const Locale('ar',''));
         }
         switch(currencyType)
         {
           case CurrencyType.sy:
             {
               currency=TranslationKeys.sy.tr;
               break;
             }
         }
       // }


    });
    Connectivity().onConnectivityChanged.listen(( result) async {
     if(!result.contains(ConnectivityResult.none ))
     {
       Future.delayed(Duration.zero,()async{
         security.value =await ALMethode.security();

         if(security.value)
         {
           security.value=true;
           SystemNavigator.pop();
         }
       });
     }
    });
  }
}