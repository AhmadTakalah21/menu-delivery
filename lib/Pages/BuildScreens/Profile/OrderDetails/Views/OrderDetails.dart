import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/Controllers/OrderDetailsControllers.dart';

import '../../../../../ALConstants/ALConstantsWidget.dart';

class OrderDetails extends GetView<OrderDetailsControllers> {
  @override
  Widget build(BuildContext context) {
    final OrderModel? order = Get.arguments['order'];

    if (order == null) {
      return Scaffold(
        body: Center(
          child: Text('❌ حدث خطأ: لا توجد بيانات للطلب', style: TextStyle(color: Colors.red)),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: AppColors.secondaryColor5,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'تفاصيل الطلب رقم ${order.id}',
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Obx(() {
          if (controller.pageState.value == 0) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.pageState.value == 2) {
            return Center(child: Text('❌ فشل في تحميل تفاصيل الطلب', style: TextStyle(color: Colors.red)));
          } else {
            return Column(
              children: [
                Expanded(
                  child: AnimationLimiter(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // ✅ تفاصيل الطلب الأساسية
                        buildDetailRow('🧑‍💼 اسم العميل:', order.user ?? 'غير متوفر'),
                        buildDetailRow('📞 رقم الهاتف:', order.userPhone ?? 'غير متوفر'),
                        buildDetailRow('📍 العنوان:', order.address ?? 'غير متوفر'),
                        buildDetailRow('💵 إجمالي السعر:', '${order.total} ل.س'),
                        buildDetailRow('📅 تاريخ الطلب:', order.createdAt ?? 'غير متوفر'),

                        const SizedBox(height: 20),

                        // ✅ عنوان تفاصيل المنتجات
                        Text(
                          '🛒 تفاصيل المنتجات:',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // ✅ عرض تفاصيل المنتجات
                        controller.orderDetails.isNotEmpty && controller.orderDetails.first.orders!.isNotEmpty
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.orderDetails.first.orders!.length,
                          itemBuilder: (context, index) {
                            final item = controller.orderDetails.first.orders![index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('📦 المنتج: ${item.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 5),
                                    Text('🔖 النوع: ${item.type}'),
                                    Text('💰 السعر: ${item.price} ل.س'),
                                    Text('🔢 الكمية: ${item.count}'),
                                    Text('📊 الإجمالي: ${item.total} ل.س'),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                            : Center(child: Text('⚠️ لا توجد تفاصيل لهذا الطلب', style: TextStyle(color: Colors.grey))),
                      ],
                    ),
                  ),
                ),

                // ✅ زر تغيير حالة الطلب
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.basicColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      String nextStatus = controller.orderDetails.first.status == 'processing'
                          ? 'under_delivery'
                          : controller.orderDetails.first.status == 'under_delivery'
                          ? 'accepted'
                          : 'accepted';

                      String confirmMessage = controller.orderDetails.first.status == 'processing'
                          ? 'هل تريد نقل الطلب إلى قيد التوصيل؟'
                          : controller.orderDetails.first.status == 'under_delivery'
                          ? 'هل تم استلام الطلب؟'
                          : 'تم تسليم الطلب بالفعل.';

                      if (controller.orderDetails.first.status != 'accepted') {
                        ALConstantsWidget.awesomeDialog(
                          controller: null,
                          title: 'تأكيد',
                          child: Text(
                            confirmMessage,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            // ✅ تحديث حالة الطلب
                            bool isSuccess = await controller.updateOrderStatus(nextStatus);

                            if (isSuccess) {
                              print("✅ نجاح التحديث، العودة للصفحة السابقة");
                              Get.offAllNamed('/OrderHistory'); // العودة إلى صفحة سجل الطلبات
                            }
                          },
                          btnOkText: 'نعم',
                          btnCancelText: 'لا',
                        );
                      } else {
                        Get.snackbar('🚫 تنبيه', 'لا يمكن تغيير حالة الطلب، الطلب مستلم بالفعل.');
                      }
                    },


                    // ✅ تغيير نص الزر بناءً على الحالة
                    child: Text(
                      controller.orderDetails.first.status == 'processing'
                          ? '🔄 نقل إلى قيد التوصيل'
                          : controller.orderDetails.first.status == 'under_delivery'
                          ? '✅ تم الاستلام'
                          : '🔄 هل تم توصيل الطلب؟',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

              ],
            );
          }
        }),
      ),
    );
  }

  /// ✅ تصميم موحد لعرض تفاصيل الطلب
  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.grayColor)),
        ],
      ),
    );
  }
}
