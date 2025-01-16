

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/ALProfileWidget.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ClassModel/ProfileModel.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Profile/Controllers/ProfileControllers.dart';
import 'package:shopping_land_delivery/Pages/MainScreenView/Controllers/MainScreenViewControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  ProfileControllers controller = Get.put(ProfileControllers());
  MainScreenViewControllers controllers = Get.find();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(body:Obx(() {
      switch (controller.pageState.value) {
        case 0:
          {
            return loadingPage();
          }
        case 1:
          {
            return previewPage();
          }
        case 2:
          {
            return errorPage();
          }
        default:
          return Container(width: Get.width, height: Get.height, color: Theme
              .of(Get.context!)
              .colorScheme
              .background,);
      }
    }));


  }



  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }
  Widget previewPage () {
    return  Column(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.only(left: 8,right: 8,top: Get.height*0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: Text(TranslationKeys.profile.tr,style: const TextStyle(fontSize: 21,fontWeight: FontWeight.w700),)),
                    GetX<ProfileControllers>(init: controller,builder: (set)=>controller.isSaveProfile.value  ?  Container(margin: EdgeInsets.only(left: Get.width*0.04,bottom: 18,top: 5),child: ALConstantsWidget.loading(height: Get.width/16,width:Get.width/16)) : TextButton(onPressed: (){
                      controller.saveProfile();
                    }, child: Text('حفظ'),style: ButtonStyle(
                        overlayColor:  MaterialStateProperty.all(AppColors.basicColor.withOpacity(0.1)),
                        foregroundColor: MaterialStateProperty.all(AppColors.basicColor)),))
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Expanded(child:
        AnimationLimiter(
          child: ListView.builder(

              physics:
              const BouncingScrollPhysics(parent:  AlwaysScrollableScrollPhysics()),
              itemCount: controller.profile.length,
              itemBuilder: (BuildContext context, int index) {
                var item =controller.profile[index];

                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    columnCount: 2,
                    child: ScaleAnimation(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child:item.styleTypeType== ProfileModelStyleType.dropDown?

                          Container(
                            height: Get.height*0.08,
                            child: GetBuilder<MainScreenViewControllers>(init: controllers,builder: (state)=>controllers.cities.isEmpty  ?const SizedBox():
                            CustomDropdown<String>(
                              maxlines: 5,
                              decoration: CustomDropdownDecoration(
                                closedBorderRadius: BorderRadius.zero,


                                  closedFillColor: const Color(0xFFF2F2F2),
                                  listItemStyle: TextStyle(fontSize: 13),
                                  headerStyle: TextStyle(fontSize: 13),


                                  closedBorder: Border.all(color: AppColors.grayColor,width: 0.2),


                                  searchFieldDecoration: SearchFieldDecoration(

                                    suffixIcon: (onClear){
                                      return IconButton(splashRadius: 20,onPressed:  onClear, icon: Icon(Icons.close,color: AppColors.secondaryColor,));
                                    },
                                    prefixIcon: Icon(Icons.search,color: AppColors.secondaryColor,),
                                  )
                              ),
                              closedHeaderPadding: EdgeInsets.only(top: 10,bottom: 10,right: 16,left:16),
                              items: controllers.cities.map((element) => element.name.toString()).toList(),
                              excludeSelected: false,

                              hintText: controllers.citiesName.value,


                              onChanged: (value)async {
                                if(controllers.citiesName.value!=value)
                                {

                                  alSettings.citiesId.value=controllers.cities.value.where((element) => element.name==value).first.id.toString();
                                  alSettings.update();
                                  controllers.citiesName.value=controllers.cities.value.where((element) => element.id.toString()== alSettings.citiesId.value).first.name.toString();
                                  alSettings.currentUser!.citiesId=alSettings.citiesId.value;
                                  ALMethode.setUserInfo(data: alSettings.currentUser!);

                                }
                              },
                            ),),
                          )
                         : item.styleTypeType== ProfileModelStyleType.textForm?
                          TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: item.controller,
                              keyboardType: item.withPhone!=null? TextInputType.number:null,
                            inputFormatters:  item.withPhone!=null?[
                                FilteringTextInputFormatter.deny(RegExp(r'[-,]')),
                              ]:[],
                            cursorColor: AppColors.secondaryColor,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(right: 10,left: 10),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0),borderSide: BorderSide(width: .8,color: Colors.redAccent.shade100)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
                              enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(0),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
                              border: InputBorder.none,
                              hintMaxLines: 1,
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: const TextStyle(fontSize: 14, color: AppColors.grayColor),
                            ),
                          )
                          :InkWell(
                              borderRadius: BorderRadius.circular(12),
                              child: ALProfileWidget(
                                key: UniqueKey(),
                                profileModel: item,
                              ),onTap:item.styleTypeType== ProfileModelStyleType.logOut || item.styleTypeType== ProfileModelStyleType.onTap ?()async{
                                 controller.onPressProfileButton(type: item.type);
                          }:null),)));
              }),))
      ],
    );
  }

  Widget errorPage () {
    return ALConstantsWidget.errorServer(callBack: (){
      controller.onInit();
    });
  }

}
