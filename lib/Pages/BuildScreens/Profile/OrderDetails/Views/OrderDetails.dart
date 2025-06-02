import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/Controllers/OrderDetailsControllers.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../ALConstants/ALConstantsWidget.dart';

class OrderDetails extends GetView<OrderDetailsControllers> {
  @override
  Widget build(BuildContext context) {
    final OrderModel? order = Get.arguments['order'];

    if (order == null) {
      return const Scaffold(
        body: Center(
          child: Text('❌ حدث خطأ: لا توجد بيانات للطلب',
              style: TextStyle(color: Colors.red)),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: AppColors.basicColor,
        systemNavigationBarColor: AppColors.basicColor,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: AppColors.basicColor,
          elevation: 4,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'تفاصيل الطلب رقم ${order.num}',
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.pageState.value == 0) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4A90E2)));
          } else if (controller.pageState.value == 2) {
            return const Center(
                child: Text('❌ فشل في تحميل تفاصيل الطلب',
                    style: TextStyle(color: Colors.red)));
          } else {
            return Column(
              children: [
                Expanded(
                  child: AnimationLimiter(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3)),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // العنوان
                              buildDetailRow(
                                '📍 العنوان:',
                                order.address ?? 'غير متوفر',
                                trailing: IconButton(
                                  icon: Icon(Icons.location_on_outlined,
                                      color: Color(0xFF4A90E2), size: 30),
                                  onPressed: () {
                                    if (order.latitude != null &&
                                        order.longitude != null) {
                                      Get.to(() => MapScreen(
                                            latitude: double.tryParse(
                                                    order.latitude!) ??
                                                0.0,
                                            longitude: double.tryParse(
                                                    order.longitude!) ??
                                                0.0,
                                          ));
                                    } else {
                                      Get.snackbar('خطأ',
                                          'لم يتم التعرف على إحداثيات الموقع',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          duration: const Duration(seconds: 3));
                                    }
                                  },
                                ),
                              ),

                              // اسم العميل
                              buildDetailRow('🧑‍💼 اسم العميل:',
                                  order.user ?? 'غير متوفر'),

                              // رقم الهاتف
                              buildDetailRow(
                                '📞 رقم الهاتف:',
                                order.userPhone ?? 'غير متوفر',
                                trailing: IconButton(
                                  icon: Icon(Icons.phone,
                                      color: Color(0xFF4A90E2), size: 30),
                                  onPressed: () async {
                                    final phoneNumber = order.userPhone ?? '';
                                    final url = 'tel:$phoneNumber';

                                    if (await canLaunch(url)) {
                                      await launch(url); // إطلاق الاتصال
                                    } else {
                                      Get.snackbar(
                                          'خطأ', 'لا يمكن إجراء الاتصال',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                          duration: const Duration(seconds: 3));
                                    }
                                  },
                                ),
                              ),

                              // رسوم التوصيل
                              buildDetailRow('🚚💸 رسوم التوصيل:',
                                  order.delivery_price ?? 'غير متوفر'),

                              // إجمالي السعر
                              buildDetailRow(
                                  '💵 إجمالي السعر:', '${order.total} ل.س'),

                              // تاريخ الطلب
                              buildDetailRow('📅 تاريخ الطلب:',
                                  order.createdAt ?? 'غير متوفر'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '🛒 تفاصيل المنتجات:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A90E2)),
                        ),
                        const SizedBox(height: 10),
                        controller.orderDetails.isNotEmpty &&
                                controller.orderDetails.first.orders!.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller
                                    .orderDetails.first.orders!.length,
                                itemBuilder: (context, index) {
                                  final item = controller
                                      .orderDetails.first.orders![index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 3,
                                    color: Color(0xFFE8F4FA),
                                    child: ListTile(
                                      leading: Icon(Icons.shopping_bag,
                                          color: Color(0xFF4A90E2)),
                                      title: Text(item.name ?? 'غير متوفر',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('🔖 النوع: ${item.type}'),
                                          Text('💰 السعر: ${item.price} ل.س'),
                                          Text('🔢 الكمية: ${item.count}'),
                                          Text(
                                              '📊 الإجمالي: ${item.total} ل.س'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text('⚠️ لا توجد تفاصيل لهذا الطلب',
                                    style: TextStyle(color: Colors.grey))),

                        const SizedBox(height: 20),

                        //// ✅ زر تغيير حالة الطلب
                        SizedBox(
                          width: 5,
                        ),
                        ALConstantsWidget.elevatedButtonWithStyle(
                          text: controller.orderDetails.first.status ==
                                  'delivered'
                              ? 'تم التوصيل' // ❌ لا يمكن تغييره
                              : 'قيد التوصيل',
                          colors: AppColors.basicColor,
                          textColor: AppColors.whiteColor,
                          onTap: () {
                            String? currentStatus =
                                controller.orderDetails.first.status;
                            String nextStatus;

                            // ✅ منع التغيير إذا كان الطلب في حالة "تم التوصيل"
                            if (currentStatus == 'delivered') {
                              Get.snackbar(
                                '🚫 إشعار',
                                ' هذا الطلب تم توصيله بالفعل ولا يمكن تغييره.',
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                              );
                              return;
                            }

                            // ✅ تحديد الحالة الجديدة بناءً على الحالة الحالية
                            if (currentStatus == 'processing') {
                              nextStatus =
                                  'under_delivery'; // 🔄 إذا كان الطلب "قيد المعالجة"، انتقل إلى "قيد التوصيل"
                            } else if (currentStatus == 'under_delivery') {
                              nextStatus =
                                  'delivered'; // ✅ إذا كان قيد التوصيل، انتقل إلى "تم التوصيل"
                            } else {
                              print(
                                  "⚠️ الحالة الحالية غير متوقعة: $currentStatus");
                              Get.snackbar(
                                '❌ خطأ',
                                '⚠️ لا يمكن تحديث الطلب، حالة غير متوقعة: $currentStatus',
                                backgroundColor: Colors.orangeAccent,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                              );
                              return;
                            }

                            // ✅ عرض حوار التأكيد قبل التحديث
                            // ✅ تحديد الرسالة بناءً على الحالة الحالية
                            String confirmationMessage;
                            if (currentStatus == 'processing') {
                              confirmationMessage = ' متأكد أنك "قيد التوصيل"؟';
                            } else if (currentStatus == 'under_delivery') {
                              confirmationMessage = 'هل تم توصيل الطلب بنجاح؟';
                            } else {
                              confirmationMessage =
                                  '⚠️ لا يمكن تغيير حالة الطلب في الوقت الحالي.';
                            }

                            // ✅ عرض Dialog مع الرسالة المعدلة

                            ALConstantsWidget.awesomeDialog(
                              controller: null,
                              child: Text(
                                confirmationMessage,
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w800),
                              ),
                              onPressed: () async {
                                bool success = await controller
                                    .UpdateOrder(); // ✅ تحديث الحالة

                                if (success) {
                                  print(
                                      "✅ تم تحديث حالة الطلب إلى: $nextStatus");
                                } else {
                                  print("❌ فشل في تحديث حالة الطلب");
                                }
                              },
                              title: 'تحديث حالة الطلب',
                              btnOkText: 'نعم',
                              btnCancelText: 'لا',
                            );
                          },
                        ),
                      ],
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

  Widget buildDetailRow(String title, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // محاذاة النص من اليسار
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(width: 8), // إضافة مسافة بين العنوان والقيمة
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis, // تقطيع النص في حال كان طويلًا
              maxLines: 2, // يسمح بعرض النص في سطرين
            ),
          ),
          if (trailing != null) trailing, // إذا كان هناك trailing يتم إضافته
        ],
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('موقع العنوان'),
        backgroundColor: Color(0xFF4A90E2),
      ),
      body: FutureBuilder<Position>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4A90E2)));
          } else if (snapshot.hasError) {
            return Center(child: Text('تعذر الحصول على الموقع الحالي'));
          } else {
            final currentPosition = snapshot.data!;

            return Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(latitude, longitude),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(latitude, longitude),
                          width: 80,
                          height: 80,
                          child: const Icon(Icons.location_on,
                              color: Colors.red, size: 40),
                        ),
                        Marker(
                          point: LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          width: 80,
                          height: 80,
                          child: const Icon(Icons.person_pin_circle,
                              color: Colors.blue, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

//// ✅ زر تغيير حالة الطلب
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.basicColor,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onPressed: () {
//                       String nextStatus = controller.orderDetails.first.status == 'processing'
//                           ? 'under_delivery'
//                           : controller.orderDetails.first.status == 'under_delivery'
//                           ? 'accepted'
//                           : 'accepted';
//
//                       String confirmMessage = controller.orderDetails.first.status == 'processing'
//                           ? 'هل تريد نقل الطلب إلى قيد التوصيل؟'
//                           : controller.orderDetails.first.status == 'under_delivery'
//                           ? 'هل تم استلام الطلب؟'
//                           : 'تم تسليم الطلب بالفعل.';
//
//                       if (controller.orderDetails.first.status != 'accepted') {
//                         ALConstantsWidget.awesomeDialog(
//                           controller: null,
//                           title: 'تأكيد',
//                           child: Text(
//                             confirmMessage,
//                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           onPressed: () async {
//                             // ✅ تحديث حالة الطلب
//                             bool isSuccess = await controller.updateOrderStatus(nextStatus);
//
//                             if (isSuccess) {
//                               print("✅ نجاح التحديث، العودة للصفحة السابقة");
//                               Get.offAllNamed('/OrderHistory'); // العودة إلى صفحة سجل الطلبات
//                             }
//                           },
//                           btnOkText: 'نعم',
//                           btnCancelText: 'لا',
//                         );
//                       } else {
//                         Get.snackbar('🚫 تنبيه', 'لا يمكن تغيير حالة الطلب، الطلب مستلم بالفعل.');
//                       }
//                     },
//
//
//                     // ✅ تغيير نص الزر بناءً على الحالة
//                     child: Text(
//                       controller.orderDetails.first.status == 'processing'
//                           ? '🔄 نقل إلى قيد التوصيل'
//                           : controller.orderDetails.first.status == 'under_delivery'
//                           ? '✅ تم الاستلام'
//                           : '🔄 هل تم توصيل الطلب؟',
//                       style: const TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ),
