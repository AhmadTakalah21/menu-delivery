




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALConstants/AppImages.dart';
import 'package:shopping_land_delivery/ALWidget/ALSells.dart';
import 'package:shopping_land_delivery/ALWidget/ALWithdrawals.dart';
import 'package:shopping_land_delivery/Model/Model/Portfolio.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Withdrawal/Controllers/WithdrawalControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class Withdrawal extends GetView<WithdrawalControllers> {
  bool? withSection;

  Withdrawal({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: AppColors.whiteColor
        ), child: Material(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.background2),
                fit: BoxFit.cover,
              )
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                leadingWidth: Get.width*0.1,
                titleSpacing: Get.width*0.001,
                title: Text(TranslationKeys.appName.tr,style: const TextStyle(color: AppColors.basicColor,fontSize: 21,fontWeight: FontWeight.w800),),
                backgroundColor: Colors.transparent,elevation: 0,leading: Padding(
              padding:  EdgeInsets.only(right: Get.height*0.015,left:   Get.height*0.015,top: Get.height*0.00),
              child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 18),onPressed: (){Get.back();},),
            )),
            body:Obx(() {
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
                  return Container(width: Get.width,height: Get.height,color: Theme.of(Get.context!).colorScheme.background,);
              }}),
          ))));
  }
  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }

  Widget previewPage () {
    return   AnimationLimiter(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],borderRadius: BorderRadius.circular(25),color: Colors.white),
                    height: Get.height/6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TranslationKeys.portfolio.tr,style: const TextStyle(fontSize: 21,fontWeight: FontWeight.w800),)
                     ,Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Expanded(child: Text(controller.portfolio.isEmpty?'0':ALMethode.formatNumberWithSeparators('${controller.portfolio.first.balance} ${alSettings.currency.tr}'),style: const TextStyle(color: AppColors.readColor,fontSize: 21,fontWeight: FontWeight.w800),)),
                        Container(height: Get.height*0.05,width: Get.width*0.3,child: ALConstantsWidget.elevatedButton(onPressed: controller.portfolio.first.balance==0?null: (){
                              ALConstantsWidget.awesomeDialog(
                              child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0,right: 8),
                                      child: StatefulBuilder(
                                          builder: (context, setState) {

                                            return  Form(
                                              key: controller.form,
                                              child: Column(
                                                  children: [
                                                    Text(TranslationKeys.balanceWithdrawal.tr,style: const TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.w800),),
                                                    SizedBox(height: Get.height*0.02,),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(child: Text(TranslationKeys.portfolio.tr,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500))),
                                                        Text(controller.portfolio.first.balance!.toString(),textAlign: TextAlign.center,style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500)),

                                                      ],
                                                    ),
                                                    SizedBox(height: Get.height*0.025,),




                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 12,right: 12),
                                                      child: Align(alignment: !alSettings.rTL.value?  Alignment.centerLeft:  Alignment.centerRight,child: Text(TranslationKeys.balanceWithdrawal.tr,style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500))),
                                                    ),


                                                    ValueListenableBuilder<TextDirection>(
                                                        valueListenable: controller.balanceWithdrawalTextDirection,
                                                        child: const SizedBox(),
                                                        builder: (context, valueTextDirection, child) =>
                                                            TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                inputFormatters:  [
                                                                  FilteringTextInputFormatter.deny(RegExp(r'[-,]')),
                                                                ],
                                                                textDirection: valueTextDirection,
                                                                validator: (val){
                                                                  if (val!.trim().isEmpty) {
                                                                    setState((){});
                                                                    return TranslationKeys.required.tr;
                                                                  }
                                                                  else if (double.parse(val.toString())<=0 || double.parse(val.toString())>double.parse(controller.portfolio.first.balance.toString())) {
                                                                    setState((){});
                                                                    return TranslationKeys.message6.tr;
                                                                  }
                                                                  else {
                                                                    return null;
                                                                  }
                                                                },
                                                                enabled: true,
                                                                controller: controller.balanceWithdrawal,
                                                                textInputAction: null,
                                                                maxLines: 1,
                                                                decoration: InputDecoration(
                                                                  contentPadding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                                                  alignLabelWithHint: true,
                                                                  border: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  hintStyle: Theme.of(context).textTheme.headlineMedium,
                                                                ),
                                                                onChanged: (val){
                                                                  if(val.isNotEmpty)
                                                                  {
                                                                    final dir = ALMethode.getDirection(val.trim());
                                                                    if (dir != valueTextDirection)
                                                                    {
                                                                      setState((){
                                                                        controller.balanceWithdrawalTextDirection.value = dir;
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                                style: const TextStyle(color: Colors.black,fontSize: 18))),


                                                    SizedBox(height: Get.height*0.03,)
                                                  ]),
                                            );
                                            }))),
                              title: TranslationKeys.edit.tr,
                              btnCancelText: TranslationKeys.cancel.tr,
                              btnOkText: TranslationKeys.ok.tr,
                              controller: null,
                              onPressed:  ()async{
                                var states = controller.form.currentState;
                                if (states!.validate()) {
                                  Get.back();
                                  controller.withdraw_money();
                                }
                              });
                        }, text: TranslationKeys.balanceWithdrawal.tr)),

                      ],)
                    ],

                  ),
                  ),
                ),

                TabBar(


                  indicator: BoxDecoration(

                    gradient: const LinearGradient(
                      colors: [
                        AppColors.secondaryColor2,
                        AppColors.secondaryColor
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Border radius
                  ),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: Get.width*0.09,vertical:Get.width*0.07), // Adjust padding as needed
                  controller: controller.tapController,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.black,
                  labelColor:Colors.white,

                  indicatorWeight: 2,
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                  labelPadding: EdgeInsets.all(25),
                  tabs:  [
                    FittedBox(child: Text(TranslationKeys.withdrawals.tr),),
                    FittedBox(child: Text(TranslationKeys.sales.tr),),
                  ],
                ),




              ],
            ),
            Container(
              height: Get.height/1.85,
              child: TabBarView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: controller.tapController, children:
              [
                ListView(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(right: Get.width*0.1,left:Get.width*0.065),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: Text(TranslationKeys.date.tr.toString(),style: const TextStyle(color: AppColors.grayColor,fontSize: 16,fontWeight: FontWeight.w600),)),
                          Text(TranslationKeys.amount.tr.toString(),style: const TextStyle(color: AppColors.basicColor,fontSize: 16,fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
            Container(height: Get.height*0.7,width: Get.width,margin: const EdgeInsets.only(top:0,left: 20,right: 20),child:
            controller.portfolio.isEmpty || controller.portfolio.first.withdrawals==null || controller.portfolio.first.withdrawals!.isEmpty?  ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
                    AnimationLimiter(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.only(bottom: Get.height*0.01),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.portfolio.first.withdrawals!.length,
                          itemBuilder: (context,index){
                            Sell item =controller.portfolio.first.withdrawals![index];
                            return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                child: ScaleAnimation(
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                      child:  Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: ALWithdrawals(
                                          key: UniqueKey(),
                                          withdrawals: item,
                                        ),
                                      ),)));
                          }),))
                  ],
                ),

                ListView(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(right: Get.width*0.1,left:Get.width*0.065),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: Text(TranslationKeys.date.tr.toString(),style: const TextStyle(color: AppColors.grayColor,fontSize: 16,fontWeight: FontWeight.w600),)),
                          Text(TranslationKeys.amount.tr.toString(),style: const TextStyle(color: AppColors.basicColor,fontSize: 16,fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(height: Get.height*0.7,width: Get.width,margin: const EdgeInsets.only(top:0,left: 20,right: 20),child:
                    controller.portfolio.isEmpty || controller.portfolio.first.sells==null || controller.portfolio.first.sells!.isEmpty? ALConstantsWidget.NotFoundData(TranslationKeys.notFoundData.tr):
                    AnimationLimiter(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.only(bottom: Get.height*0.01),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.portfolio.first.sells!.length,
                          itemBuilder: (context,index){
                            Sells item =controller.portfolio.first.sells![index];
                            return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                child: ScaleAnimation(
                                    duration: const Duration(milliseconds: 900),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                      child:  Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: ALSells(
                                          key: UniqueKey(),
                                          sell: item,
                                        ),
                                      ),)));
                          }),))
                  ],
                ),

              ],
              ),
            ),
          ],
        ),
      );

  }

  Widget errorPage () {
    return ALConstantsWidget.errorServer(callBack: (){
      controller.onInit();
    });
  }
}



