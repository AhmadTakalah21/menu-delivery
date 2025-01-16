


import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/Brands/Views/Brands.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Views/Cart.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Favorite/Controllers/FavoriteControllers.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Favorite/Views/Favorite.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Views/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Profile/Views/Profile.dart';
import 'package:shopping_land_delivery/Pages/MainScreenView/Controllers/MainScreenViewControllers.dart';
import 'package:shopping_land_delivery/main.dart';
import 'package:uuid/uuid.dart';


class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> with WidgetsBindingObserver  {
  MainScreenViewControllers controller = Get.put(MainScreenViewControllers());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state==AppLifecycleState.resumed)
    {

      Future.delayed(Duration.zero,()async{
        alSettings.security.value =await ALMethode.security();

        if(alSettings.security.value)
        {
          alSettings.security.value=true;
          SystemNavigator.pop();
        }
      });
    }

    // Handle other states if needed
  }


  @override
  Widget build(BuildContext context) {
   return GetX<MainScreenViewControllers>(init: controller,builder: (set)=> AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness:Brightness.light,
             statusBarColor: AppColors.basicColor,
             systemNavigationBarColor: AppColors.basicColor,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: AppColors.basicColor,

        ),
       child: Material(color: Theme.of(context).scaffoldBackgroundColor,
        child: DefaultTextStyle(
          style: TextStyle(fontFamily: 'Almarai-Light'),
          child: Container(

            child: Scaffold(

              backgroundColor: AppColors.secondaryColor5,
              appBar: controller.indexScreen.value!=0? null : AppBar(

                elevation: 0,
                centerTitle: false,

                leadingWidth: Get.width*0.2,
                backgroundColor: AppColors.secondaryColor5,
                leading:    FloatingActionButton(
                  heroTag:const Uuid().v4() ,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: (){
                    ALMethode.logout();
                  },
                  child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        const gradient = LinearGradient(
                          colors: <Color>[
                            Color(0xff707070),
                            Color(0xff707070),

                          ],
                        );
                        return gradient.createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn, // This is important to preserve icon's transparency
                      child: Icon(Icons.logout,color: AppColors.readColor,)) ,
                ),
                actions: [
                  Container(
                      padding: EdgeInsets.only(left: Get.width*0.05),
                      alignment: Alignment.centerRight,
                      child:ExtendedImage.asset(AppImages.logo2, width: Get.width*0.4,)

                  )
                ],
              ),

              body:  GetBuilder<MainScreenViewControllers>(builder: (state){
                switch(controller.indexScreen.value)
                {
                  case 0:
                    {

                      return OrderHistory();
                    }
                  case 1:
                    {
                      return const Brands();
                    }
                  case 2:
                    {
                      try {
                        FavoriteControllers controllers = Get.find();
                        controllers.onInit();
                      }
                      catch(e){}
                      return const Favorite();
                    }
                  case 3:
                    {
                      try {
                        CartControllers controllers = Get.find();
                        controllers.onInit();
                      }
                      catch(e){}
                      return  const Cart();
                    }
                  case 4:
                    {
                      return const Profile();
                    }

                  default:{
                    return const SizedBox();
                  }
                }
              }),

            ),
          ),
        ))));
  }



  Widget bottomNavigationBar ()
  {
    return GetBuilder<MainScreenViewControllers>(builder: (state)=> Container(

      child: BottomBarBubble(
        backgroundColor: AppColors.basicColor,
        color: AppColors.secondaryColor3,
        bubbleSize: 15,
        selectedIndex: controller.indexScreen.value,
        items:controller.listConvex,
        onSelect: (index) {
          controller.indexScreen.value = index;
          controller.update();
          try{
            CartControllers controllers = Get.find();
            controllers.isCheckDiscount.value=false;
            controllers.discountId.value='';
            controllers.isCheckDiscount.value=false;
            controllers.discount.clear();
          }
          catch(E){

          }
        })),




      //  ListView.builder(
      //         itemCount: controller.listConvex.length,
      //         scrollDirection: Axis.horizontal,
      //         padding: EdgeInsets.only(right: Get.width * .02,left:Get.width * .05 ),
      //         itemBuilder: (context, index) => InkWell(
      //           onTap: () {
      //               controller.indexScreen.value = index;
      //               HapticFeedback.lightImpact();
      //               controller.update();
      //               try{
      //                 CartControllers controllers = Get.find();
      //                 controllers.isCheckDiscount.value=false;
      //                 controllers.discountId.value='';
      //                 controllers.isCheckDiscount.value=false;
      //                 controllers.discount.clear();
      //               }
      //               catch(E){
      //
      //               }
      //           },
      //           splashColor: Colors.transparent,
      //           highlightColor: Colors.transparent,
      //           child: Stack(
      //             children: [
      //               AnimatedContainer(
      //                 duration: const Duration(seconds: 1),
      //                 curve: Curves.fastLinearToSlowEaseIn,
      //                 width: index == controller.indexScreen.value
      //                     ?controller.listConvex[index].title.tr.length>=9? Get.width * .4 :  Get.width * .30
      //                     : Get.width * .16,
      //                 alignment: Alignment.center,
      //                 child: AnimatedContainer(
      //                   duration: const Duration(seconds: 1),
      //                   curve: Curves.fastLinearToSlowEaseIn,
      //                   height: index == controller.indexScreen.value ? Get.width * .09 : 0,
      //                   width: index == controller.indexScreen.value ? controller.listConvex[index].title.tr.length>=9? Get.width * .33 : Get.width * .30 : 0,
      //                   decoration: BoxDecoration(
      //                     color: index == controller.indexScreen.value
      //                         ?  Colors.white
      //                         : Colors.transparent,
      //                     borderRadius: BorderRadius.circular(25),
      //                   ),
      //                 ),
      //               ),
      //               AnimatedContainer(
      //                 duration: const Duration(seconds: 1),
      //                 curve: Curves.fastLinearToSlowEaseIn,
      //                 width: index == controller.indexScreen.value
      //                     ? Get.width * .35
      //                     : Get.width * .15,
      //                 alignment: Alignment.center,
      //                 child: Stack(
      //                   children: [
      //                     Row(
      //                       children: [
      //                         AnimatedContainer(
      //                           duration: const Duration(seconds: 1),
      //                           curve: Curves.fastLinearToSlowEaseIn,
      //                           width:
      //                           index == controller.indexScreen.value ?  controller.listConvex[index].title.tr.length>=9? Get.width * .09 :Get.width * .12 : 0,
      //                         ),
      //                         AnimatedOpacity(
      //                           opacity: index == controller.indexScreen.value ? 1 : 0,
      //                           duration: const Duration(seconds: 1),
      //                           curve: Curves.fastLinearToSlowEaseIn,
      //                           child: Text(
      //                             index == controller.indexScreen.value
      //                                 ? controller.listConvex[index].title.tr
      //                                 : '',
      //                             style: const TextStyle(
      //                               color: AppColors.grayColor,
      //                               fontWeight: FontWeight.w700,
      //                               fontSize: 14,
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     Row(
      //                       children: [
      //                         AnimatedContainer(
      //                           duration: const Duration(seconds: 1),
      //                           curve: Curves.fastLinearToSlowEaseIn,
      //                           width:
      //                           index == controller.indexScreen.value ? controller.listConvex[index].title.tr.length>=9? Get.width * .04 : Get.width * .06 : 10,
      //                         ),
      //                         Icon(
      //                           controller.listConvex[index].icon,
      //                           size: Get.width * .050,
      //                           color: index == controller.indexScreen.value
      //                               ? AppColors.secondaryColor
      //                               : Colors.white,
      //                         ),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),


    );
  }
}



