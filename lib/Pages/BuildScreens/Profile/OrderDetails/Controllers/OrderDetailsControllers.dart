import 'dart:convert';
import 'dart:io';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/Model/Model/OrderDetails.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/Repositories/OrderDetailsRepositories.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Controllers/OrderHistoryControllers.dart';

class OrderDetailsControllers extends GetxController {
  RxList<OrderDetailsM> orderDetails = <OrderDetailsM>[].obs;
  late String title;
  RxInt pageState = 1.obs;
  late OrderModel order;

  /// ✅ استقبال بيانات الطلب عند الانتقال للصفحة
  OrderDetailsControllers() {
    order = Get.arguments['order'];
    title = Get.arguments['title'];
  }

  /// ✅ تحميل تفاصيل الطلب بناءً على ID
  Future<void> display_order_by_id() async {
    try {
      pageState.value = 0;

      // ✅ طباعة قيمة id قبل الإرسال
      print("📦 Order ID being sent: ${order.id}");

      // ✅ تحقق من وجود order.id
      if (order.id == null || order.id.toString().isEmpty) {
        pageState.value = 2;
        Get.snackbar('❌ خطأ', '⚠️ معرف الطلب غير موجود أو غير صحيح');
        return;
      }

      OrderDetailsRepositories repositories = OrderDetailsRepositories();

      // ✅ تغيير المفتاح إلى id إذا كان الخادم يتطلبه
      bool isSuccess = await repositories.display_order_by_id(bodyData: {
        'id': order.id.toString(),  // ✅ استخدم المفتاح الصحيح
      });

      if (isSuccess && repositories.message.data != null) {
        var data = json.decode(json.decode(repositories.message.data));

        if (data['orders'] != null && data['orders'].isNotEmpty) {
          orderDetails.value = dataOrderDetailsMFromJson(json.encode([data]));
          pageState.value = 1;
        } else {
          pageState.value = 2;
          Get.snackbar('⚠️ لا توجد بيانات', '🚫 لا توجد تفاصيل لهذا الطلب');
        }
      } else {
        pageState.value = 2;
        Get.snackbar('❌ خطأ', '⚠️ فشل في تحميل تفاصيل الطلب');
      }
    } catch (e) {
      pageState.value = 2;
      Get.snackbar('❌ خطأ', '🚨 حدث خطأ أثناء تحميل تفاصيل الطلب: $e');
    }
  }
  /// ✅ تحديث حالة الطلب (قيد التوصيل أو تم التوصيل)
  Future<bool> updateOrderStatus(String nextStatus) async {
    print("🔄 بدء تحديث حالة الطلب إلى: $nextStatus");
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);
    SVProgressHUD.show();

    try {
      OrderDetailsRepositories repositories = OrderDetailsRepositories();

      // ✅ استدعاء API لتحديث حالة الطلب
      bool isUpdated = await repositories.updateOrder(bodyData: {
        'id': order.id.toString(),
        'status': nextStatus,
      });

      SVProgressHUD.dismiss();

      if (isUpdated) {
        print("✅ تم تحديث حالة الطلب بنجاح إلى: $nextStatus");
        Get.snackbar('✅ نجاح', 'تم تحديث حالة الطلب إلى $nextStatus');

        // ✅ تحديث حالة الطلب في الواجهة
        orderDetails.first.status = nextStatus;
        update();

        // ✅ تحديث سجل الطلبات
        try {
          print("🔄 تحديث سجل الطلبات...");
          OrderHistoryControllers controllers = Get.find();
          controllers.onInit();
        } catch (e) {
          print("⚠️ تعذر تحديث سجل الطلبات: $e");
          Get.snackbar('⚠️ تنبيه', 'تعذر تحديث سجل الطلبات');
        }

        // ✅ العودة إلى صفحة سجل الطلبات بعد نجاح التحديث
        Future.delayed(const Duration(milliseconds: 500), () {
          print("🔙 العودة إلى صفحة سجل الطلبات...");
          Get.offAllNamed('/OrderHistory');  // العودة إلى صفحة سجل الطلبات
        });

        return true;  // ✅ نجاح العملية
      } else {
        print("❌ فشل في تحديث حالة الطلب");
        Get.snackbar('❌ خطأ', 'فشل في تحديث حالة الطلب');
        return false;
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      print("❌ خطأ أثناء تحديث الطلب: $e");
      Get.snackbar('❌ خطأ', 'حدث خطأ أثناء تحديث الطلب: $e');
      return false;
    }
  }





  /// ✅ تحميل البيانات عند فتح الصفحة
  @override
  void onInit() {
    super.onInit();
    display_order_by_id();
  }
}



