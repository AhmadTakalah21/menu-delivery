





import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/Model/Model/OrderDetails.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/Repositories/OrderDetailsRepositories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Controllers/OrderHistoryControllers.dart';

class OrderDetailsControllers extends GetxController {

  RxList<OrderDetailsM> orderDetails =<OrderDetailsM>[].obs;
  late String title;
  RxInt pageState=1.obs;
  late OrderModel order;
  OrderDetailsControllers()
  {
    order=Get.arguments['order'];
    title=Get.arguments['title'];
  }

  // ✅ تحميل تفاصيل الطلب بناءً على ID مع تصحيح الحالة المستلمة من السيرفر
  Future<void> display_order_by_id() async {
    try {
      pageState.value = 0;
      OrderDetailsRepositories repositories = OrderDetailsRepositories();

      if (await repositories.display_order_by_id(bodyData: {'id': order.id.toString()})) {
        if (repositories.message.data != null) {
          var data = json.decode(json.decode(repositories.message.data));

          // ✅ استخراج الحالة المستلمة من السيرفر
          String receivedStatus = data["status"].toString().toLowerCase(); // جعلها بحروف صغيرة للمقارنة
          print("📌 الحالة المستلمة من السيرفر: $receivedStatus");

          // ✅ تصحيح الحالات الغير معروفة
          if (receivedStatus == "paid") {
            receivedStatus = "delivered"; // 🔥 تصحيح "Paid" إلى "processing"
            print("! تم استلام حالة غير معروفة 'Paid', يتم تصحيحها إلى 'delivered'...");
          }  else if (receivedStatus == "processing") {
            receivedStatus = "processing"; // 🔥 تصحيح "Under delivery"
            print("! تم استلام حالة غير معروفة 'processing', يتم تصحيحها إلى 'processing'...");
          }
          else if (receivedStatus == "under delivery") {
            receivedStatus = "under_delivery"; // 🔥 تصحيح "Under delivery"
            print("! تم استلام حالة غير معروفة 'Under delivery', يتم تصحيحها إلى 'under_delivery'...");
          }

          // ✅ تحديث الحالة المصححة قبل حفظ البيانات
          data["status"] = receivedStatus;

          // ✅ تحديث البيانات في التطبيق
          orderDetails.value = dataOrderDetailsMFromJson(json.encode([data]));
          print("📌 الحالة بعد التصحيح: ${orderDetails.first.status}");

          pageState.value = 1;
        } else {
          pageState.value = 2;
        }
      } else {
        pageState.value = 2;
      }
    } catch (E) {
      pageState.value = 2;
    }
  }


  Future<bool> UpdateOrder() async {
    Get.back(); // إغلاق الـ Dialog

    if (Platform.isIOS) {
      SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native);
    }
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);
    SVProgressHUD.show(); // عرض مؤشر التحميل

    OrderDetailsRepositories repositories = OrderDetailsRepositories();

    // تحديد الحالة الجديدة للطلب
    String newStatus =
    orderDetails.first.status != 'under_delivery' ? 'under_delivery' : 'delivered';

    bool success = await repositories.updateOrder(
        bodyData: {'id': order.id.toString(), 'status': newStatus});

    SVProgressHUD.dismiss(); // إخفاء مؤشر التحميل

    if (success) {
      try {
        OrderHistoryControllers controllers = Get.find();
        controllers.update(); // ✅ تحديث GetX لضمان تحديث الواجهة
      } catch (e) {
        print("⚠️ Warning: OrderHistoryControllers not found.");
      }

      // ✅ إشعار نجاح
      Get.snackbar(
        'نجاح',
        '✅ تم تحديث حالة الطلب إلى "$newStatus" بنجاح!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      return true; // ✅ العملية نجحت
    } else {
      // ❌ إشعار فشل
      Get.snackbar(
        'خطأ',
        '⚠️ فشل في تحديث الطلب، يرجى المحاولة مرة أخرى.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      return false; // ❌ العملية فشلت
    }
  }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    display_order_by_id();
  }

}