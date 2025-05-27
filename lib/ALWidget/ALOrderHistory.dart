import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/ALMethode.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';

typedef OnTap = void Function();

class ALOrderHistory extends StatefulWidget {
  OrderModel orderHistoryM;
  OnTap onTap;

  ALOrderHistory({super.key, required this.onTap, required this.orderHistoryM});

  @override
  State<ALOrderHistory> createState() => _ALOrderHistoryState();
}

class _ALOrderHistoryState extends State<ALOrderHistory> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(Get.width * 0.04),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.secondaryColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ رقم الطلب
            Text(
              'رقم الطلب: ${widget.orderHistoryM.num ?? 'غير متوفر'}',
              style: TextStyle(
                  color: AppColors.secondaryColor, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: Get.height * 0.03),

            // ✅ اسم العميل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${TranslationKeys.name.tr}:',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.orderHistoryM.user ?? 'غير متوفر',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 10),

            // ✅ رقم الهاتف
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'رقم الهاتف:',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.orderHistoryM.userPhone ?? 'غير متوفر',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 10),

            // ✅ السعر الكلي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${TranslationKeys.price.tr}',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  ALMethode.formatNumberWithSeparators(widget.orderHistoryM.total ?? '0') + ' ل.س',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 10),

            // ✅ العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'العنوان:',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: Get.width * 0.02),  // Add a small space between the label and value
                Expanded(
                  child: Text(
                    widget.orderHistoryM.address ?? 'غير متوفر',
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis, // Show ellipsis if the text overflows
                  ),
                ),
              ],

            ),
            SizedBox(height: 10),

            // ✅ تاريخ الطلب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تاريخ الطلب:',
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.orderHistoryM.createdAt ?? 'غير متوفر',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
