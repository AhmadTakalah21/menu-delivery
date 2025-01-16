

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/Configuration/config.dart';
import 'package:shopping_land_delivery/Services/Translations/Language/Arabic.dart';
import 'package:shopping_land_delivery/Services/Translations/Language/English.dart';
import 'package:shopping_land_delivery/Services/Translations/Language/French.dart';


class LocalString extends Translations{
  @override
  Map<String, Map<String, String>> get keys => {
    'en':English.english,
    'ar':Arabic.arabic,
    'fr':French.french
  };

  static var local =[
    {'name':'Arabic','local':const Locale('ar','')},
    {'name':'English' ,'local':const Locale('en','')},
    {'name':'French' ,'local':const Locale('fr','')}
  ];

  static setLocal() async {
    var local =await ALMethode.getSharedPreferencesWithType(kay: 'locale',type: SharedPreferencesType.string);
    if(local!=null && local.isNotEmpty)
      {
        localTranslations=  Locale(local,'');
      }
    Get.updateLocale(localTranslations);
  }
  static String getLanguage()
  {
    String language= '';
    switch (localTranslations.languageCode.toString()){
      case 'ar': { language ='Arabic' ; break; }
      case 'en': { language ='English'; break;}
      case 'fr': { language ='French' ;break ;}
    }
    return language;
  }
  static UpdateTranslations(Locale local) async {
    var localString =await ALMethode.getSharedPreferencesWithType(kay: 'locale',type: SharedPreferencesType.string);
     if(localString!=null)
       {
         ALMethode.addSharedPreferencesWithType(kay: 'locale',value: local.languageCode,type: SharedPreferencesType.string);
       }
     else
       {
         ALMethode.addSharedPreferencesWithType(kay: 'locale',value: local.languageCode,type: SharedPreferencesType.string);
       }
     setLocal();
  }
}