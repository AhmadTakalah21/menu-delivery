




import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/Percents.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
typedef OnChanged = void Function(int);

class ALPercents extends StatefulWidget {
  Percents percents;
  OnChanged onChanged;
  ALPercents({
    super.key,
    required this.onChanged,
    required this.percents
  });

  @override
  State<ALPercents> createState() => _ALPercentsState();
}

class _ALPercentsState extends State<ALPercents> {
 List<String> item =[
   "0%",
   "1%",
   "2%",
   "3%",
   "4%",
   "5%",
   "6%",
   "7%",
   "8%",
   "9%",
   "10%",
   "11%",
   "12%",
   "13%",
   "14%",
   "15%",
   "16%",
   "17%",
   "18%",
   "19%",
   "20%",
   "21%",
   "22%",
   "23%",
   "24%",
   "25%",
   "26%",
   "27%",
   "28%",
   "29%",
   "30%",
   "31%",
   "32%",
   "33%",
   "34%",
   "35%",
   "36%",
   "37%",
   "38%",
   "39%",
   "40%",
   "41%",
   "42%",
   "43%",
   "44%",
   "45%",
   "46%",
   "47%",
   "48%",
   "49%",
   "50%",
   "51%",
   "52%",
   "53%",
   "54%",
   "55%",
   "56%",
   "57%",
   "58%",
   "59%",
   "60%",
   "61%",
   "62%",
   "63%",
   "64%",
   "65%",
   "66%",
   "67%",
   "68%",
   "69%",
   "70%",
   "71%",
   "72%",
   "73%",
   "74%",
   "75%",
   "76%",
   "77%",
   "78%",
   "79%",
   "80%",
   "81%",
   "82%",
   "83%",
   "84%",
   "85%",
   "86%",
   "87%",
   "88%",
   "89%",
   "90%",
   "91%",
   "92%",
   "93%",
   "94%",
   "95%",
   "96%",
   "97%",
   "98%",
   "99%",
   "100%",
 ];
  String hint='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hint=widget.percents.percent!=null &&  widget.percents.percent!>0? '${widget.percents.percent}%': TranslationKeys.select.tr;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color:  Colors.transparent,
            border: Border(bottom: BorderSide(width: .4,color: AppColors.grayColor))),
        child:
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child:Container(
                child:Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ExtendedImage.network(
                          widget.percents.itemImage.toString(),
                          width: Get.width*0.25,
                          height: Get.width*0.25,
                          headers: ALMethode.getApiHeader(),
                          fit: BoxFit.fill,
                          cache: true,
                          handleLoadingProgress: true,
                          timeRetry: const Duration(seconds: 1),
                          printError: true,
                          timeLimit  :const Duration(seconds: 1),
                          borderRadius: BorderRadius.circular(20),
                          loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.failed:
                                return GestureDetector(
                                  key: UniqueKey(),
                                  onTap: () {
                                    state.reLoadImage();
                                  },
                                  child: Container(
                                    width: Get.width,
                                    height: Get.height*0.16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child:const Icon(CupertinoIcons.refresh_circled_solid,size: 40,color: AppColors.basicColor,semanticLabel: 'failed',),
                                  ),
                                );
                              case LoadState.loading:
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: Get.width,
                                      height: Get.height*0.16,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    Container(child:
                                    Platform.isAndroid? const CircularProgressIndicator(color: AppColors.grayColor,strokeWidth: 1,backgroundColor: AppColors.whiteColor,) :  CupertinoActivityIndicator(radius: 15),
                                    )
                                  ],
                                );
                              case LoadState.completed:
                              // TODO: Handle this case.
                                break;
                            }
                            return null;
                          }
                        //cancelToken: cancellationToken,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(widget.percents.itemName.toString(),maxLines: 5,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 13),),
                          const SizedBox(height: 5,),
                          Text(widget.percents.categoryName.toString(),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 12,),maxLines: 5),
                          // const SizedBox(height: 5,),

                          // Text(widget.percents.percent.toString(),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),

                        ],),
                    )
                  ],
                ) ,
              )),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height*0.01,),
                    Container(
                      width: Get.width*0.25,
                      child:
                      CustomDropdown<String>(
                        maxlines: 5,

                        decoration: CustomDropdownDecoration(
                            closedFillColor: const Color(0xFFF2F2F2),
                            listItemStyle: TextStyle(fontSize: 13),
                            headerStyle: TextStyle(fontSize: 13),

                            closedBorder: Border.all(color: AppColors.basicColor,width: 0.5),


                            searchFieldDecoration: SearchFieldDecoration(

                              suffixIcon: (onClear){
                                return IconButton(splashRadius: 20,onPressed:  onClear, icon: Icon(Icons.close,color: AppColors.secondaryColor,));
                              },
                              prefixIcon: Icon(Icons.search,color: AppColors.secondaryColor,),
                            )
                        ),



                        closedHeaderPadding: EdgeInsets.only(top: Get.height*0.002,bottom: Get.height*0.002,right: Get.width*0.02,left: Get.width*0.02),
                        items: item,
                        excludeSelected: false,
                        hintText: hint,
                        onChanged: (value)async {
                            widget.onChanged(int.parse(value.replaceAll('%', '').toString()));

                        },
                      ),
                    ),

                  ],

                ),
              ),

            ]

        ));

  }
}
