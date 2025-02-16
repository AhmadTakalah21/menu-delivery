import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_land_delivery/ALConstants/AppPages.dart';
import 'package:shopping_land_delivery/ALSettings/ALSettings.dart';
import 'package:shopping_land_delivery/Services/Translations/LocalConfigration/LocalString.dart';
import 'package:shopping_land_delivery/Services/location_services/location_service_controller.dart';
import 'package:geolocator/geolocator.dart';

ALSettings alSettings = Get.put(ALSettings());
LocationController _locationController = Get.put(LocationController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
          overflow: TextOverflow.ellipsis
      ),
      child: SafeArea(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Menu Delivery",
          initialRoute: Routes.SPLASH,
          theme: ThemeData(useMaterial3: false,),
          translations: LocalString(),
          getPages: AppPages.routes,
          routingCallback: (routing) {
            alSettings.routeName.value = routing!.current;
          },
          onInit: () async {
            String? userId = alSettings.currentUser?.userId;
            String? token = alSettings.currentUser?.apiKey;

            if (userId != null && token != null) {
              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                print("🚫 خدمة الموقع غير مفعلة، لن يتم تشغيل التتبع.");
                return;
              }

              LocationPermission permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                print("🚫 إذن الموقع مرفوض، لن يتم تشغيل التتبع.");
                return;
              }

              await _locationController.startLocationTracking(userId, token);
            }
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:shopping_land_delivery/ALConstants/AppColors.dart';
// import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
// import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/Controllers/OrderDetailsControllers.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
//
// import '../../../../../ALConstants/ALConstantsWidget.dart';
//
// class OrderDetails extends GetView<OrderDetailsControllers> {
//   @override
//   Widget build(BuildContext context) {
//     final OrderModel? order = Get.arguments['order'];
//
//     if (order == null) {
//       return Scaffold(
//         body: Center(
//           child: Text('❌ حدث خطأ: لا توجد بيانات للطلب', style: TextStyle(color: Colors.red)),
//         ),
//       );
//     }
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarIconBrightness: Brightness.dark,
//         systemNavigationBarIconBrightness: Brightness.dark,
//         systemNavigationBarColor: Colors.white,
//       ),
//       child: Scaffold(
//         backgroundColor: Color(0xFFF5F5F5),
//         appBar: AppBar(
//           backgroundColor: Color(0xFF4A90E2),
//           elevation: 4,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
//             onPressed: () {
//               Get.back();
//             },
//           ),
//           title: Text(
//             'تفاصيل الطلب رقم ${order.num}',
//             style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//         ),
//         body: Obx(() {
//           if (controller.pageState.value == 0) {
//             return const Center(child: CircularProgressIndicator(color: Color(0xFF4A90E2)));
//           } else if (controller.pageState.value == 2) {
//             return Center(child: Text('❌ فشل في تحميل تفاصيل الطلب', style: TextStyle(color: Colors.red)));
//           } else {
//             return Column(
//               children: [
//                 Expanded(
//                   child: AnimationLimiter(
//                     child: ListView(
//                       padding: const EdgeInsets.all(16),
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
//                             ],
//                           ),
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             children: [
//                               buildDetailRow(
//                                 '📍 العنوان:',
//                                 order.address ?? 'غير متوفر',
//                                 trailing: IconButton(
//                                   icon: Icon(Icons.location_on, color: Color(0xFF4A90E2)),
//                                   onPressed: () {
//                                     if (order.latitude != null && order.longitude != null) {
//                                       Get.to(() => MapScreen(
//                                         latitude: double.tryParse(order.latitude!) ?? 0.0,
//                                         longitude: double.tryParse(order.longitude!) ?? 0.0,
//                                       ));
//                                     } else {
//                                       Get.snackbar('خطأ', 'لم يتم التعرف على إحداثيات الموقع');
//                                     }
//                                   },
//                                 ),
//                               ),
//                               buildDetailRow('🧑‍💼 اسم العميل:', order.user ?? 'غير متوفر'),
//                               buildDetailRow('📞 رقم الهاتف:', order.userPhone ?? 'غير متوفر'),
//                               buildDetailRow('🚚💸 رسوم التوصيل:', order.delivery_price ?? 'غير متوفر'),
//                               buildDetailRow('💵 إجمالي السعر:', '${order.total} ل.س'),
//                               buildDetailRow('📅 تاريخ الطلب:', order.createdAt ?? 'غير متوفر'),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           '🛒 تفاصيل المنتجات:',
//                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A90E2)),
//                         ),
//                         const SizedBox(height: 10),
//                         controller.orderDetails.isNotEmpty && controller.orderDetails.first.orders!.isNotEmpty
//                             ? ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: controller.orderDetails.first.orders!.length,
//                           itemBuilder: (context, index) {
//                             final item = controller.orderDetails.first.orders![index];
//                             return Card(
//                               margin: const EdgeInsets.symmetric(vertical: 8),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               elevation: 3,
//                               color: Color(0xFFE8F4FA),
//                               child: ListTile(
//                                 leading: Icon(Icons.shopping_bag, color: Color(0xFF4A90E2)),
//                                 title: Text(item.name ?? 'غير متوفر', style: TextStyle(fontWeight: FontWeight.bold)),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('🔖 النوع: ${item.type}'),
//                                     Text('💰 السعر: ${item.price} ل.س'),
//                                     Text('🔢 الكمية: ${item.count}'),
//                                     Text('📊 الإجمالي: ${item.total} ل.س'),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         )
//                             : Center(child: Text('⚠️ لا توجد تفاصيل لهذا الطلب', style: TextStyle(color: Colors.grey))),
//
//                         const SizedBox(height: 20),
//
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFF4A90E2),
//                               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               shadowColor: Color(0xFF357ABD),
//                               elevation: 6,
//                             ),
//                             onPressed: () {
//                               String currentStatus = controller.orderDetails.first.status?.trim().toLowerCase() ?? '';
//                               String nextStatus = '';
//                               String confirmMessage = '';
//
//                               if (currentStatus == 'processing') {
//                                 nextStatus = 'under_delivery';
//                                 confirmMessage = 'هل تريد نقل الطلب إلى قيد التوصيل؟';
//                               } else if (currentStatus == 'under_delivery') {
//                                 nextStatus = 'delivered';
//                                 confirmMessage = 'هل تريد نقل الطلب إلى المستلمة؟';
//                               } else if (currentStatus == 'delivered') {
//                                 confirmMessage = 'تم تسليم الطلب بالفعل.';
//                               } else {
//                                 confirmMessage = 'لا يمكن تغيير حالة الطلب.';
//                               }
//
//                               if (currentStatus != 'delivered') {
//                                 ALConstantsWidget.awesomeDialog(
//                                   controller: null,
//                                   title: 'تأكيد العملية',
//                                   child: Text(
//                                     confirmMessage,
//                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A90E2)),
//                                   ),
//                                   onPressed: () async {
//                                     if (nextStatus.isNotEmpty) {
//                                       bool isSuccess = await controller.updateOrderStatus(nextStatus);
//                                       print('✅ استجابة الخادم: $isSuccess'); // ✅ تتبع الاستجابة
//
//                                       if (isSuccess) {
//                                         // ✅ إعادة تحميل تفاصيل الطلب من السيرفر
//                                         controller.orderDetails.first.status = nextStatus;
//                                         Get.offAllNamed('/OrderHistory'); // إعادة تحميل صفحة سجل الطلبات
//                                       } else {
//                                         Get.snackbar(
//                                           '❗ خطأ',
//                                           'فشل في تحديث حالة الطلب. حاول لاحقًا.',
//                                           backgroundColor: Colors.redAccent,
//                                           colorText: Colors.white,
//                                         );
//                                       }
//                                     }
//                                   },
//                                   btnOkText: 'نعم',
//                                   btnCancelText: 'لا',
//                                 );
//                               } else {
//                                 Get.snackbar('🚫 تنبيه', confirmMessage, backgroundColor: Colors.orangeAccent, colorText: Colors.white);
//                               }
//                             },
//
//
//
//                             child: Text(
//                               controller.orderDetails.first.status == 'processing'
//                                   ? '🚚 تغيير حالة الطلب ؟ '
//                                   : controller.orderDetails.first.status == 'under_delivery'
//                                   ? '📦 تأكيد التسليم'
//                                   : '✅ الطلب مستلم',
//                               style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//
//
//
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//         }),
//       ),
//     );
//   }
//
//   Widget buildDetailRow(String title, String value, {Widget? trailing}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A90E2))),
//           Row(
//             children: [
//               Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87)),
//               if (trailing != null) trailing,
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MapScreen extends StatelessWidget {
//   final double latitude;
//   final double longitude;
//
//   const MapScreen({Key? key, required this.latitude, required this.longitude}) : super(key: key);
//
//   Future<Position> _getCurrentLocation() async {
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('موقع العنوان'),
//         backgroundColor: Color(0xFF4A90E2),
//       ),
//       body: FutureBuilder<Position>(
//         future: _getCurrentLocation(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator(color: Color(0xFF4A90E2)));
//           } else if (snapshot.hasError) {
//             return Center(child: Text('تعذر الحصول على الموقع الحالي'));
//           } else {
//             final currentPosition = snapshot.data!;
//
//             return Container(
//               margin: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: FlutterMap(
//                   options: MapOptions(
//                     initialCenter: LatLng(latitude, longitude),
//                     initialZoom: 13.0,
//                   ),
//                   children: [
//                     TileLayer(
//                       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     ),
//                     MarkerLayer(
//                       markers: [
//                         Marker(
//                           point: LatLng(latitude, longitude),
//                           width: 80,
//                           height: 80,
//                           child: Icon(Icons.location_on, color: Colors.red, size: 40),
//                         ),
//                         Marker(
//                           point: LatLng(currentPosition.latitude, currentPosition.longitude),
//                           width: 80,
//                           height: 80,
//                           child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }




// const SizedBox(height: 20),
//
// Container(
// padding: const EdgeInsets.all(10),
// child: ElevatedButton(
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.deepPurpleAccent,
// padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(20),
// ),
// shadowColor: Colors.deepPurple,
// elevation: 6,
// ),
// onPressed: () {
// String nextStatus = controller.orderDetails.first.status == 'processing'
// ? 'under_delivery'
//     : controller.orderDetails.first.status == 'under_delivery'
// ? 'accepted'
//     : 'accepted';
//
// String confirmMessage = controller.orderDetails.first.status == 'processing'
// ? 'هل تريد نقل الطلب إلى قيد التوصيل؟'
//     : controller.orderDetails.first.status == 'under_delivery'
// ? 'هل تم استلام الطلب؟'
//     : 'تم تسليم الطلب بالفعل.';
//
// if (controller.orderDetails.first.status != 'accepted') {
// ALConstantsWidget.awesomeDialog(
// controller: null,
// title: 'تأكيد',
// child: Text(
// confirmMessage,
// style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// ),
// onPressed: () async {
// bool isSuccess = await controller.updateOrderStatus(nextStatus);
// if (isSuccess) {
// Get.offAllNamed('/OrderHistory');
// }
// },
// btnOkText: 'نعم',
// btnCancelText: 'لا',
// );
// } else {
// Get.snackbar('🚫 تنبيه', 'لا يمكن تغيير حالة الطلب، الطلب مستلم بالفعل.');
// }
// },
// child: Text(
// controller.orderDetails.first.status == 'processing'
// ? '🚚 نقل إلى قيد التوصيل'
//     : controller.orderDetails.first.status == 'under_delivery'
// ? '✅ تأكيد الاستلام'
//     : '📦 الطلب مستلم',
// style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
// ),
// ),
// ),