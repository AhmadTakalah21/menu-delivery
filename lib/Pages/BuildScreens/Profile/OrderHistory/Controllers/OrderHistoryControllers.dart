





import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/Model/Model/DeliveryType.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Repositories/OrderHistoryRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
enum OrderHistoryStatus { processing, under_delivery, accepted }
class OrderHistoryControllers extends GetxController with GetTickerProviderStateMixin{
  TextEditingController dateController=TextEditingController();
  TextEditingController searchController=TextEditingController();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  OrderHistoryStatus orderHistoryStatus=OrderHistoryStatus.processing;
  RxInt pageState=1.obs;
  RxBool isClearDate= false.obs;
  RxBool changeIndexState=false.obs;
  RxBool keyboardVisibility=false.obs;
  String title =TranslationKeys.pending.tr;
  RxList<OrderModel> orderHistory =<OrderModel>[].obs;
  RxList<DeliveryType> type =<DeliveryType>[].obs;
  late TabController tapController= TabController(length: 3,initialIndex: 0, vsync: this);
  GlobalKey<FormState> form = GlobalKey<FormState>();
  bool empty =false;
  int page =2;
  RxString typeName='all'.obs;
  RxString typeId='all'.obs;
  RxBool isActive = false.obs;



  Future<void> display_delivery_type() async{
    try
    {
      OrderHistoryRepositories repositories  =OrderHistoryRepositories();
      if(await repositories.display_delivery_type())
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          type.value =dataDeliveryTypeMFromJson(json.encode(data['delivery_types']));
          type.add(DeliveryType(name: 'all'));
        }
      }
    }
    catch(E)
    {
      pageState.value=2;
    }
  }
  Future<void> updateActiveStatus(bool isActive) async {
    try {
      // تعريف الـ Repository داخل الدالة
      OrderHistoryRepositories repositories = OrderHistoryRepositories();

      // استدعاء التابع من الـ Repository
      bool success = await repositories.changeActiveToWork();

      if (success) {
        Get.snackbar('Success', 'Status updated successfully');
        this.isActive.value = isActive; // تحديث الحالة محليًا
      } else {
        Get.snackbar('Error', 'Failed to update status');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }




  Future<void> get_orders() async{
    try
    {
      pageState.value=0;
      await display_delivery_type();



      OrderHistoryRepositories repositories  =OrderHistoryRepositories();
      if(await repositories.display_orders(bodyData: {'perPage':'10','status':orderHistoryStatus.name}))
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          orderHistory.value =dataOrderHistoryMFromJson(json.encode(data['orders']));
        }
        pageState.value=1;
      }
      else
      {
        pageState.value=2;
      }
    }
    catch(E)
    {
      pageState.value=2;
    }
  }



  Future<void> getOrdersStatus() async{
    OrderHistoryRepositories repositories  =OrderHistoryRepositories();
    if(await repositories.display_orders(bodyData: {'status':orderHistoryStatus.name}))
    {
      orderHistory.clear();
        if(repositories.message.data!=null)
          {
            var data = json.decode(json.decode(repositories.message.data));
            orderHistory.value = List<OrderModel>.from(
              data.map((x) => OrderModel.fromJson(x as Map<String, dynamic>)),
            );

          }
        changeIndexState.value=false;
    }
    else
    {
      pageState.value=2;
    }
  }



  Future<void> changedIndex({required int index}) async {
    try {
      // ✅ تعيين حالة التحميل لعرض مؤشر التحميل
      pageState.value = 0;  // 0 => جاري التحميل

      // ✅ إعادة تعيين التحكم بالتحديث
      refreshController = RefreshController(initialRefresh: false);

      // ✅ تحديث حالة الطلب بناءً على التبويبة المختارة
      switch (index) {
        case 0: // قيد المعالجة
          orderHistoryStatus = OrderHistoryStatus.processing;
          title = TranslationKeys.pending.tr;
          break;

        case 1: // قيد التوصيل
          orderHistoryStatus = OrderHistoryStatus.under_delivery;
          title = TranslationKeys.processing.tr;
          break;

        case 2: // تم التوصيل
          orderHistoryStatus = OrderHistoryStatus.accepted;
          title = TranslationKeys.delivered.tr;
          break;
      }

      // ✅ تعيين حالة التغيير لتحديث الواجهة
      changeIndexState.value = true;

      // ✅ استدعاء البيانات بناءً على التبويب المحدد
      await getOrdersStatus();

      // ✅ تعيين حالة التحميل إلى ناجح
      pageState.value = 1;  // 1 => تم التحميل بنجاح
    } catch (e) {
      // ❌ في حالة حدوث خطأ يتم تعيين حالة الخطأ
      pageState.value = 2;  // 2 => فشل في التحميل
      Get.snackbar('❌ خطأ', 'حدث خطأ أثناء تحميل الطلبات: $e');
      print('❌ خطأ أثناء تحميل الطلبات: $e');
    }
  }





  Future<void> getListOfRefresh()async{
    try{
      page=2;
      empty=false;
      OrderHistoryRepositories repositories  =OrderHistoryRepositories();
      Map<String, String> body ={
        'perPage':'10',
        'status':orderHistoryStatus.name,
        'page':'1',
      };
      if(typeId.value!=TranslationKeys.all && typeId.value!=TranslationKeys.all.tr)
      {
        body.addAll({'filter[num]':typeId.value.toString()});
      }

      if(searchController.text.trim().isNotEmpty)
      {
        body.addAll({'search':searchController.text.trim(),});
      }
      if(dateController.text.trim().isNotEmpty)
      {
        body.addAll({'filter[created_at]':dateController.text.trim(),});
      }
      if(await repositories.display_orders(bodyData:body))
      {
        if(repositories.message.data!=null)
        {
          var data = json.decode(json.decode(repositories.message.data));
          orderHistory.value =dataOrderHistoryMFromJson(json.encode(data['orders']));
        }
        refreshController.refreshCompleted();
      }
      else
      {
        refreshController.refreshFailed();
      }
    }
    catch(e) {
      refreshController.refreshFailed();
    }

  }



  Future<void> getListOfLoading()async{


      try{
        OrderHistoryRepositories repositories  =OrderHistoryRepositories();

        Map<String, String> body ={
          'perPage':'10',
          'status':orderHistoryStatus.name,
          'page':page.toString(),
        };
        if(typeId.value!=TranslationKeys.all && typeId.value!=TranslationKeys.all.tr)
        {
          body.addAll({'filter[num]':typeId.value.toString()});
        }

        if(searchController.text.trim().isNotEmpty)
        {
          body.addAll({'search':searchController.text.trim(),});
        }
        if(dateController.text.trim().isNotEmpty)
        {
          body.addAll({'filter[created_at]':dateController.text.trim(),});
        }
        if(await repositories.display_orders(bodyData: body))
        {
          RxList<OrderModel> orderHistoryNew =<OrderModel>[].obs;
          if(repositories.message.data!=null)
          {
            var data = json.decode(json.decode(repositories.message.data));

            orderHistoryNew.value =dataOrderHistoryMFromJson(json.encode(data['orders']));
          }
          if(orderHistoryNew.isEmpty)
          {
            empty=true;
            refreshController.loadComplete();
          }
          else
          {
            orderHistory.addAll(orderHistoryNew);
            refreshController.loadComplete();
            update();
            page++;
          }
        }
        else
        {
          refreshController.loadFailed();
        }
      }
      catch(e) {
        refreshController.loadFailed();
      }

  }



  Future<void> filterProduct() async {
    page = 2;
    changeIndexState.value = true;

    OrderHistoryRepositories repositories = OrderHistoryRepositories();

    // ✅ إعداد البيانات الأساسية للفلترة
    Map<String, String> body = {
      'perPage': '10',
      'status': orderHistoryStatus.name,
      'page': '1',
    };

    print('🔎 بدء عملية الفلترة...');
    print('📦 البيانات الأولية للفلترة: $body');

    // ✅ فلترة حسب رقم الطلب (num)
    if (searchController.text.trim().isNotEmpty) {
      String searchText = searchController.text.trim();
      print('🔍 البحث عن: $searchText');

      if (int.tryParse(searchText) != null) {
        body.addAll({'search': searchText});
        print('🔢 البحث باستخدام رقم الطلب: ${body['filter[num]']}');
      }
    }

    // ✅ فلترة حسب التاريخ (created_at)
    if (dateController.text.trim().isNotEmpty) {
      body.addAll({'created_at': dateController.text.trim()});
      print('📅 البحث باستخدام التاريخ: ${body['filter[created_at]']}');
    }

    print('📤 إرسال طلب API مع البيانات: $body');

    if (await repositories.display_orders(bodyData: body)) {
      print('✅ تم الاتصال بـ API بنجاح.');

      if (repositories.message.data != null) {
        var data = json.decode(json.decode(repositories.message.data));
        print('📥 البيانات المستلمة من API: $data');

        // ✅ التحقق من نوع البيانات وتصحيح المعالجة
        if (data is List) {
          orderHistory.value = dataOrderHistoryMFromJson(json.encode(data));
          print('📊 عدد الطلبات بعد الفلترة: ${orderHistory.length}');
        } else if (data is Map && data.containsKey('orders')) {
          orderHistory.value = dataOrderHistoryMFromJson(json.encode(data['orders']));
          print('📊 عدد الطلبات بعد الفلترة: ${orderHistory.length}');
        } else {
          print('❌ البيانات غير متوقعة أو خاطئة: $data');
          orderHistory.clear();
        }
      } else {
        print('⚠️ البيانات المستلمة من السيرفر فارغة.');
        orderHistory.clear();
      }

      changeIndexState.value = false;
    } else {
      pageState.value = 2;
      print('❌ فشل في الاتصال بـ API أو الاستجابة غير صحيحة.');
      Get.snackbar('خطأ', 'فشل في تحميل الطلبات');
    }
  }







  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getOrdersStatus();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      keyboardVisibility.value=visible;
      update();
    });

    typeId.listen((p0) {
      filterProduct();
    });

  }
}