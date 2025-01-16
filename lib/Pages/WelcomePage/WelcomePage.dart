



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALWidget/SLTextAnimation.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}




class _WelcomePageState extends State<WelcomePage>   with TickerProviderStateMixin{
  late Animation<double> opacity;
  late Animation<double> transform;
   ScrollController scrollController = ScrollController();
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,

      duration: const Duration(seconds: 3),
    );
    opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ),);
    opacity.addListener(() {
      setState(() {

      });
    });

    transform = Tween<double>(begin: 2, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ),);
    Future.delayed(Duration(seconds: 1),(){
      controller.forward();
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness:Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.secondaryColor3,
            statusBarColor: AppColors.secondaryColor3,
            systemNavigationBarDividerColor: AppColors.secondaryColor3
        ),
        child: DefaultTextStyle(
          style: TextStyle( fontFamily: 'comicbd'),
          child: Material(
            color: AppColors.secondaryColor3,
              child:Scaffold(
                  body:SizedBox(
                    height: Get.height,
                    child: Container(
                      alignment: Alignment.center,
                      decoration:  BoxDecoration(
                          color: AppColors.secondaryColor3,
                          image: DecorationImage(
                            image: AssetImage(AppImages.background2),
                            fit: BoxFit.fill,
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            SLTextAnimation(
                              delayStart: const Duration(milliseconds: 1000),
                              animationDuration: const Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              offset: 5,
                              child: Text('Menu_Delivery',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(height: Get.height*0.01,),
                            SLTextAnimation(
                              delayStart: const Duration(milliseconds: 1300),
                              animationDuration: const Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              offset: 5,
                              child: Text('online delivery',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w100)),
                            ),
                          ],),

                          ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: SingleChildScrollView(
                                  controller: scrollController,
                                  child:Opacity(
                                      opacity: opacity.value,
                                      child:Transform.scale(
                                          scale:  transform.value,
                                          child: Container(
                                              width: Get.width * .9,
                                              height: Get.width * 0.4,
                                              decoration: BoxDecoration(
                                                color:  Colors.transparent,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: SingleChildScrollView(child: Column(children: [
                                                ALConstantsWidget.elevatedButtonWithStyle(
                                                    text: TranslationKeys.signIn.tr,
                                                    colors: AppColors.whiteColor,
                                                    textColor: AppColors.basicColor,
                                                    onTap: (){
                                                      Get.toNamed(Routes.SingIn);
                                                    }
                                                ),

                                              ],)))))))
                        ],
                      )
                    ),
                  ))),
        ));
  }
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection,
      ) {
    return child;
  }
}