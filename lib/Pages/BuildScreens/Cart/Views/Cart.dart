import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shopping_land_delivery/ALConstants/ALConstantsWidget.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/ALWidget/ALCart.dart';
import 'package:shopping_land_delivery/Model/Model/CartModel.dart';
import 'package:shopping_land_delivery/Model/Model/DeliveryTypes.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';
import 'package:shopping_land_delivery/Pages/MainScreenView/Controllers/MainScreenViewControllers.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:shopping_land_delivery/main.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  CartControllers controller = Get.put(CartControllers());
  MainScreenViewControllers controllers = Get.find();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(systemNavigationBarColor: Color(0xfff8f8f8),statusBarIconBrightness: Brightness.light, systemNavigationBarIconBrightness: Brightness.light, systemNavigationBarDividerColor: AppColors.basicColor), child: Material(color: Colors.transparent,
        child: SafeArea(child:Obx(() {
          switch (controller.pageState.value)
          {
            case 1:
              {
                return previewPage();
              }
            case 2:
              {
                return errorPage();
              }
            default:
              return  Container(width: Get.width,height: Get.height,);
          }}),)));
  }

  Widget loadingPage () {
    return Center(child: ALConstantsWidget.loading(height: Get.width/12,width:Get.width/12),);
  }

  Widget previewPage () {
    return Padding(
      padding: const EdgeInsets.only(right: 14,left: 14),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Container(padding: EdgeInsets.only(top: Get.height*0.05),width: Get.width,alignment: Alignment.center,child: Text(TranslationKeys.cart.tr,style: TextStyle(color: AppColors.grayColor,fontSize: 18,fontWeight: FontWeight.w600),)),
              controller.pageStateCart.value==0  ? Container(height: Get.height*0.7,child: loadingPage()):
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(width: Get.width,margin: const EdgeInsets.only(top: 0),child:
                    (controller.pageStateCart.value==1 && ( controller.carts.isEmpty || (controller.carts.first.carts==null || controller.carts.first.carts!.isEmpty) ))? ALConstantsWidget.NotFoundData(TranslationKeys.notCart.tr):
                    controller.pageStateCart.value==0  ? loadingPage():
                    AnimationLimiter(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: Get.height*0.01),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.carts.first.carts!.length,
                          itemBuilder: (context,index){
                            Carts item =controller.carts.first.carts![index];
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
                                        child: ALCart(
                                          totalPriceAfterDiscount: controller.carts.first.totalPriceAfterDiscount.toString(),
                                          controller: controller,
                                          onDelete: (){
                                            ALConstantsWidget.showDialogIosOrAndroid(
                                                content: "${TranslationKeys.message3.tr} \"${item.item!.name.toString()} \" " ,
                                                onPressOKButton: ()async{
                                                  Get.back();

                                                },
                                                delete: true,
                                                towButton: true);
                                          },
                                          onEdite: (){

                                          },
                                          key: UniqueKey(),
                                          carts: item,
                                        ),
                                      ),)));
                          }),)),
                    SizedBox(height: Get.height*0.02,),
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: Alignment.center,height: Get.height*0.06,child: Text('نوع التوصيل:',style: const TextStyle(color: AppColors.grayColor,fontWeight: FontWeight.w500,fontSize: 16),)),
                        SizedBox(width: Get.width*0.02,),
                        Container(
                          height: Get.height*0.06,
                          width: Get.width*0.7,
                          child:
                          CustomDropdown<DeliveryTypes>(
                            maxlines: 5,
                            headerBuilder: (c,item){
                              return Text(controller.deliveryTypesName.value);
                            },
                            decoration: CustomDropdownDecoration(
                                closedBorderRadius: BorderRadius.circular(100),
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
                            closedHeaderPadding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left:16),
                            listItemBuilder: (BuildContext c, DeliveryTypes item,bool isActiv,  Function()){

                              return  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Text(item.name!,style: const TextStyle(color: AppColors.grayColor,fontWeight: FontWeight.w400,fontSize: 16),),
                               Text('${item.fromPrice.toString()}-${item.toPrice.toString()}',style: const TextStyle(color: AppColors.secondaryColor,fontWeight: FontWeight.w400,fontSize: 16),),

                        ],
                        );
                            },
                            items: controller.deliveryTypes.value.toList(),
                            excludeSelected: false,

                            hintText: controller.deliveryTypesName.value,



                            onChanged: (value)async {
                              if(controller.deliveryTypesName.value!=value.name)
                              {

                                controller.deliveryTypesName.value= value.name.toString();
                                controller.deliveryTypesId.value=controller.deliveryTypes.value.where((element) => element.name.toString()== value.name).first.id.toString();

                              }
                            },
                          ),),
                      ],
                    ),



                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: Alignment.center,height: Get.height*0.06,child: Text('طريقة الدفع: ',style: const TextStyle(color: AppColors.grayColor,fontWeight: FontWeight.w500,fontSize: 16),)),
                        SizedBox(width: Get.width*0.02,),
                        Container(
                          height: Get.height*0.05,
                          width: Get.width*0.71,
                          child:
                          CustomDropdown<String>(
                            maxlines: 5,

                            decoration: CustomDropdownDecoration(
                                closedBorderRadius: BorderRadius.circular(100),

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
                            closedHeaderPadding: EdgeInsets.only(top: 8,bottom: 8,right: 16,left:16),
                            items: controller.methodTypes.map((element) => element.name.toString()).toList(),
                            excludeSelected: false,

                            hintText: controller.methodTypesName.value,



                            onChanged: (value)async {
                              if(controller.methodTypesName.value!=value)
                              {

                                controller.methodTypesName.value= value;
                                controller.methodTypesId.value=controller.methodTypes.value.where((element) => element.name.toString()== value).first.id.toString();

                              }
                            },
                          ),),
                      ],
                    ),
                  SizedBox(width: Get.width*0.01,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: Alignment.center,height: Get.height*0.06,child: Text('كود الحسم:   ',style: const TextStyle(color: AppColors.grayColor,fontWeight: FontWeight.w500,fontSize: 16),)),
                        SizedBox(width: Get.width*0.02,),
                        Container(
                          height: Get.height*0.05,
                          width: Get.width*0.71,
                          child:  TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: controller.code,
                            cursorColor: AppColors.secondaryColor,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: (){
                                  if(controller.code.text.trim().isNotEmpty)
                                    {
                                      controller.check_coupon();
                                    }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: Get.width*0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(100),bottomLeft: Radius.circular(100) ),
                                    color: AppColors.basicColor
                                  ),
                                  child: FittedBox(child: Text(TranslationKeys.confirm.tr,style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(right: 10,left: 10),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: BorderSide(width: .8,color: Colors.redAccent.shade100)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .8,color: AppColors.grayColor)) ,
                              enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide: const BorderSide(width: .4,color: AppColors.grayColor)) ,
                              border: InputBorder.none,
                              hintMaxLines: 1,
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: const TextStyle(fontSize: 14, color: AppColors.grayColor),
                            ),
                          )
                         ,),
                      ],
                    ),

                   if(controller.discount.isNotEmpty)
                     SizedBox(width: Get.width*0.01,),
                     if(controller.discount.isNotEmpty)
                     Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(alignment: Alignment.center,height: Get.height*0.06,width: Get.width*0.18,child: Text(controller.code.text.trim(),style: const TextStyle(color: AppColors.grayColor,fontWeight: FontWeight.w500,fontSize: 16),)),
              SizedBox(width: Get.width*0.02,),
              Container(
                height: Get.height*0.05,
                width: Get.width*0.71,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(controller.discount.first.amount.toString()+'%',style: const TextStyle(color: AppColors.readColor,fontWeight: FontWeight.w500,fontSize: 16)),
                      SizedBox(width: Get.width*0.05,),
                      Text(ALMethode.formatNumberWithSeparators(controller.discount.first.percent.toString()),style: const TextStyle(color: AppColors.secondaryColor,fontWeight: FontWeight.w500,fontSize: 16)),
                ])
                ,),
            ],
          ),
             SizedBox(height: Get.width*0.1,),
                    Container(
                      width: Get.width*0.85,
                      decoration: BoxDecoration(
                          boxShadow:[BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.1,
                            blurRadius: 0.5,
                            offset: const Offset(0, 1), // changes position of shadow
                          )],
                          color:  Colors.white,
                          borderRadius: BorderRadius.circular(12),
                         ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: Get.width*0.05,),
                          Text('تفاصيل الطلب',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
                          SizedBox(height: Get.width*0.05,),

                          Container(

                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.3,color: AppColors.grayColor))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text('نوع التوصيل:',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),
                                Text(controller.deliveryTypesName.value.toString(),style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),

                              ],),
                            ),
                          ),

                          Container(

                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.3,color: AppColors.grayColor))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('تاريخ الطلب:',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),
                                  Text(intl.DateFormat('yyyy/MM/dd').format(DateTime.now()).toString(),style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),

                                ],),
                            ),
                          ),

                          Container(

                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.3,color: AppColors.grayColor))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('تاريخ التوصيل المتوقع:',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),
                                  if(controller.deliveryTypesId.value.isNotEmpty)
                                  Text(intl.DateFormat('yyyy/MM/dd').format(DateTime.now().add(Duration(days: controller.deliveryTypes.value.where((element) => element.id.toString()==controller.deliveryTypesId.value).first.toDays!))).toString(),style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),

                                ],),
                            ),
                          ),


                          SizedBox(height: Get.width*0.15,),

                          Container(

                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.3,color: AppColors.grayColor))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('السعر قبل الحسم:',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),
                                  Text(ALMethode.formatNumberWithSeparators(controller.carts.first.totalPriceAfterDiscount.toString()),style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),

                                ],),
                            ),
                          ),

                          Container(

                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.3,color: AppColors.grayColor))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('السعر بعد الحسم:',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),
                                  if(controller.discount.isNotEmpty)
                                  Text(ALMethode.formatNumberWithSeparators(controller.discount.first.percent.toString()),style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16))
                                  else
                                  Text('لايوجد',style: const TextStyle(color:AppColors.readColor,fontWeight: FontWeight.w500,fontSize: 16))


                                ],),
                            ),
                          ),

                          Container(

                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.3,color: AppColors.grayColor))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('سعر التوصيل:',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 16)),
                                  if(controller.deliveryTypesId.value.isNotEmpty)
                                    Text('${controller.deliveryTypes.value.where((element) => element.id.toString()==controller.deliveryTypesId.value).first.fromPrice!.toString()}-${controller.deliveryTypes.value.where((element) => element.id.toString()==controller.deliveryTypesId.value).first.toPrice!.toString()}',style: const TextStyle(color:AppColors.grayColor,fontWeight: FontWeight.w500,fontSize: 16)),

                                ],),
                            ),
                          ),


                          SizedBox(height: Get.width*0.05,),
                          Container(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('السعر الإجمالي:',style: const TextStyle(color:Colors.black,fontWeight: FontWeight.w900,fontSize: 16)),
                                  SizedBox(width: Get.width*0.03,),
                                  if(controller.deliveryTypesId.value.isNotEmpty)
                                  Text(controller.discount.isNotEmpty?ALMethode.formatNumberWithSeparators((controller.discount.first.percent!+controller.deliveryTypes.value.where((element) => element.id.toString()==controller.deliveryTypesId.value).first.toPrice!).toString()).toString()   : ALMethode.formatNumberWithSeparators((controller.carts.first.totalPriceAfterDiscount!+controller.deliveryTypes.value.where((element) => element.id.toString()==controller.deliveryTypesId.value).first.toPrice!).toString()).toString(),style: const TextStyle(color:AppColors.secondaryColor,fontWeight: FontWeight.w900,fontSize: 16)),

                                ],),
                            ),
                          ),

                          SizedBox(height: Get.width*0.05,),


                          ALConstantsWidget.elevatedButtonWithStyle(
                              text: TranslationKeys.sendOrder.tr,
                              colors: AppColors.secondaryColor,
                              textColor: AppColors.whiteColor,
                              onTap: (){
                                ALConstantsWidget.awesomeDialog(
                                    controller: controller.btnController,
                                    child:  SingleChildScrollView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0,right: 8),
                                            child: StatefulBuilder(
                                                builder: (context, State) {

                                                  return  Form(
                                                    key:controller.form,
                                                    child: Column(
                                                        children: [
                                                          Text('الدفع',style: const TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.w800),),
                                                          SizedBox(height: Get.height*0.01,),

                                                          Text('إدخال البيانات',style: const TextStyle(fontSize: 18,color: AppColors.grayColor,fontWeight: FontWeight.w500),),

                                                          SizedBox(height: Get.height*0.025,),

                                                          TextFormField(
                                                              validator: (val){
                                                                if (val!.trim().isEmpty)
                                                                {
                                                                  return TranslationKeys.required.tr;
                                                                }
                                                                else {
                                                                  return null;
                                                                }
                                                              },
                                                              enabled: true,
                                                              controller: controller.name,
                                                              textInputAction: null,
                                                              maxLines: 1,
                                                              decoration: InputDecoration(
                                                                  contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                                                                  hintStyle: TextStyle(color: AppColors.grayColor,fontSize: 13),                                                                  alignLabelWithHint: true,
                                                                  border: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  hintText: TranslationKeys.name.tr
                                                              ),
                                                              style: const TextStyle(color: Colors.black,fontSize: 18)),
                                                          SizedBox(height: Get.height*0.025,),
                                                          TextFormField(
                                                              validator: (val){
                                                                if (val!.trim().isEmpty)
                                                                {
                                                                  return TranslationKeys.required.tr;
                                                                }
                                                                else {
                                                                  return null;
                                                                }
                                                              },
                                                              enabled: true,
                                                              controller: controller.name2,
                                                              textInputAction: null,
                                                              maxLines: 1,
                                                              decoration: InputDecoration(
                                                                  contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                                                                  hintStyle: TextStyle(color: AppColors.grayColor,fontSize: 13),                                                                  alignLabelWithHint: true,
                                                                  border: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  hintText:'الكنية'
                                                              ),
                                                              style: const TextStyle(color: Colors.black,fontSize: 18)),
                                                          SizedBox(height: Get.height*0.025,),

                                                          Container(
                                                            height: Get.height*0.05,
                                                            child: GetBuilder<MainScreenViewControllers>(init: controllers,builder: (state)=>controllers.cities.isEmpty  ?const SizedBox():
                                                            CustomDropdown<String>(
                                                              maxlines: 5,
                                                              decoration: CustomDropdownDecoration(
                                                                  closedBorderRadius: BorderRadius.circular(100),
                                                                  listItemStyle: TextStyle(fontSize: 13),
                                                                  headerStyle: TextStyle(fontSize: 13),


                                                                  closedBorder: Border.all(color: AppColors.grayColor,width: 0.8),


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
                                                          ),

                                                          SizedBox(height: Get.height*0.025,),
                                                          TextFormField(
                                                              validator: (val){
                                                                if (val!.trim().isEmpty)
                                                                {
                                                                  return TranslationKeys.required.tr;
                                                                }
                                                                else {
                                                                  return null;
                                                                }
                                                              },
                                                              keyboardType: TextInputType.number,
                                                              inputFormatters:  [
                                                                FilteringTextInputFormatter.deny(RegExp(r'[-,]')),
                                                              ],
                                                              enabled: true,
                                                              controller: controller.phone,
                                                              textInputAction: null,
                                                              maxLines: 1,
                                                              decoration: InputDecoration(
                                                                  contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                                                                  hintStyle: TextStyle(color: AppColors.grayColor,fontSize: 13),
                                                                  alignLabelWithHint: true,
                                                                  border: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors.black, width: 0.5),
                                                                    borderRadius: BorderRadius.circular(100),
                                                                  ),
                                                                  hintText: TranslationKeys.phone.tr
                                                              ),
                                                              style: const TextStyle(color: Colors.black,fontSize: 18)),

                                                          SizedBox(height: Get.height*0.025,),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextFormField(
                                                                    validator: (val){
                                                                      if (val!.trim().isEmpty)
                                                                      {
                                                                        return TranslationKeys.required.tr;
                                                                      }
                                                                      else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                    enabled: true,
                                                                    controller: controller.address,
                                                                    textInputAction: null,
                                                                    maxLines: 1,
                                                                    decoration: InputDecoration(
                                                                        contentPadding:  EdgeInsets.only(top: 5,left: Get.width*0.05,right: Get.width*0.05),
                                                                        hintStyle: TextStyle(color: AppColors.grayColor,fontSize: 13),                                                                  alignLabelWithHint: true,
                                                                        border: OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.black, width: 0.5),
                                                                          borderRadius: BorderRadius.circular(100),
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.black, width: 0.5),
                                                                          borderRadius: BorderRadius.circular(100),
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.black, width: 0.5),
                                                                          borderRadius: BorderRadius.circular(100),
                                                                        ),
                                                                        hintText: TranslationKeys.deliveryAddress.tr
                                                                    ),
                                                                    style: const TextStyle(color: Colors.black,fontSize: 18)),
                                                              ),
                                                              SizedBox(width: Get.width*0.01,),
                                                              SizedBox(width: Get.width*0.1,height: Get.width*0.1,child: FloatingActionButton(onPressed: null,elevation: 3,backgroundColor: AppColors.secondaryColor,child: Icon(MdiIcons.mapMarker,color: AppColors.whiteColor,))),
                                                            ],
                                                          ),

                                                          SizedBox(height: Get.height*0.03,)
                                                        ]),
                                                  );}))),
                                    title: TranslationKeys.choseLanguage.tr,
                                    btnCancelText: TranslationKeys.cancel,
                                    btnOkText: TranslationKeys.confirm.tr,
                                    onPressed: ()async{
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      var states = controller.form.currentState;
                                      if (states!.validate()) {
                                        await SystemChannels.textInput.invokeMethod('TextInput.hide');

                                         controller.addOrder();

                                      }
                                      else
                                      {
                                        controller.btnController.reset();
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      }
                                    });
                              }
                          ),

                          SizedBox(height: Get.width*0.05,),


                        ],
                      ),



                    ),
                          SizedBox(height: Get.width*0.05,),








                  ],
                ),
              ),




            ],
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
