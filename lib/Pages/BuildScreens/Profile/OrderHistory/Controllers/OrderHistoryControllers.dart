





import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shopping_land_delivery/Model/Model/DeliveryType.dart';
import 'package:shopping_land_delivery/Model/Model/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Repositories/OrderHistoryRepositories.dart';
import 'package:shopping_land_delivery/Services/Translations/TranslationKeys/TranslationKeys.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../main.dart';
enum OrderHistoryStatus { processing, under_delivery, accepted }
class OrderHistoryControllers extends GetxController with GetTickerProviderStateMixin{
  TextEditingController dateController=TextEditingController();
  TextEditingController searchController=TextEditingController();
  // RefreshController refreshController = RefreshController(initialRefresh: false);

  /// ✅ إنشاء `RefreshController` لكل `Tab`
  RefreshController refreshControllerPending = RefreshController();
  RefreshController refreshControllerProcessing = RefreshController();
  RefreshController refreshControllerDelivered = RefreshController();

  OrderHistoryStatus orderHistoryStatus = OrderHistoryStatus.processing;
  RxInt pageState = 1.obs;
  RxBool isClearDate = false.obs;
  RxBool changeIndexState = false.obs;
  RxBool keyboardVisibility = false.obs;
  String title = TranslationKeys.pending.tr;
  RxList<OrderModel> orderHistory = <OrderModel>[].obs;
  RxList<DeliveryType> type = <DeliveryType>[].obs;
  late TabController tapController = TabController(length: 3, initialIndex: 0, vsync: this);
  GlobalKey<FormState> form = GlobalKey<FormState>();
  bool empty = false;
  int page = 2;
  RxString typeName = 'all'.obs;
  RxString typeId = 'all'.obs;
  RxBool isActive = false.obs;
  WebSocketChannel? _channel;
  bool _isConnected = false;
  String userId = alSettings.currentUser!.userId!;




  void initWebSocket() {
    _channel?.sink.close();

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.40:8080/app/bqfkpognxb0xxeax5bjc'),
    );

    _channel?.stream.listen(
      _handleIncomingMessage,
      onError: (error) {
        print("❌ خطأ في الاتصال: $error");
        _reconnect();
      },
      onDone: () {
        if (_isConnected) {
          print("🔌 الاتصال انقطع بشكل غير متوقع");
          _reconnect();
        }
      },
    );
  }










  void _handleIncomingMessage(dynamic message) {
    print("📩 الرسالة الواردة: $message");

    try {
      final decoded = jsonDecode(message);

      if (decoded['event'] == 'pusher:connection_established') {
        _isConnected = true;
        _subscribeToChannel();
        return;
      }

      if (decoded['event'] == 'pusher:error') {
        print("⚠️ خطأ في Pusher: ${decoded['data']}");
        return;
      }

      if (decoded['event'] == 'App\\Events\\OrderUpdated') {
        var data = json.decode(decoded['data']);
        var updatedOrders = data['orders'] as List;

        for (var updatedOrder in updatedOrders) {
          var existingOrderIndex = orderHistory.indexWhere((order) => order.id == updatedOrder['id']);
          if (existingOrderIndex != -1) {
            orderHistory[existingOrderIndex] = OrderModel.fromJson(updatedOrder);
          } else {
            orderHistory.add(OrderModel.fromJson(updatedOrder));
          }
        }
        update();
        Get.snackbar(
          "تحديث الطلبات",
          "تم تحديث حالة الطلبات",

          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );// Trigger UI update
      }
    } catch (e) {
      print("❌ خطأ في تحليل الرسالة: $e");
    }
  }



  void _subscribeToChannel() {
    _channel?.sink.add(jsonEncode({
      "event": "pusher:subscribe",
      "data": {"channel": "all-orders.${orderHistoryStatus.name}.$userId"}
    }));
    print("🔄 جاري الاشتراك في قناة all-orders...");
  }




  void _reconnect() {
    _isConnected = false;
    Future.delayed(Duration(seconds: 3), () {
      print("⚡ محاولة إعادة اتصال...");
      initWebSocket();
    });
  }


  @override
  void onClose() {
    _channel?.sink.close();
    super.onClose();
  }

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



  Future<void> getOrdersStatus() async {
    OrderHistoryRepositories repositories  = OrderHistoryRepositories();
    if (await repositories.display_orders(bodyData: {'status': orderHistoryStatus.name})) {
      orderHistory.clear();
      if (repositories.message.data != null) {
        var data = json.decode(json.decode(repositories.message.data));
        orderHistory.value = List<OrderModel>.from(
          data.map((x) => OrderModel.fromJson(x as Map<String, dynamic>)),
        );
      }
      changeIndexState.value = false;
      update(); // Trigger UI update
    } else {
      pageState.value = 2;
    }
  }



  Future<void> changedIndex({required int index}) async {
    OrderHistoryStatus newOrderHistoryStatus = OrderHistoryStatus.under_delivery;
    switch (index) {
      case 0:
        newOrderHistoryStatus = OrderHistoryStatus.processing;
        title = TranslationKeys.pending.tr;
        break;
      case 1:
        newOrderHistoryStatus = OrderHistoryStatus.under_delivery;
        title = TranslationKeys.processing.tr;
        break;
      case 2:
        newOrderHistoryStatus = OrderHistoryStatus.accepted;
        title = TranslationKeys.delivered.tr;
        break;
    }

    if (newOrderHistoryStatus != orderHistoryStatus) {
      orderHistoryStatus = newOrderHistoryStatus;
      changeIndexState.value = true;
      await getOrdersStatus();
    }
  }





  /// ✅ تحديث `getListOfRefresh` ليعمل لكل `Tab` بشكل منفصل
  Future<void> getListOfRefresh(int tabIndex) async {
    try {
      page = 2;
      empty = false;
      OrderHistoryRepositories repositories = OrderHistoryRepositories();

      Map<String, String> body = {
        'perPage': '10',
        'status': orderHistoryStatus.name,
        'page': '1',
      };

      if (await repositories.display_orders(bodyData: body)) {
        if (repositories.message.data != null) {
          var data = json.decode(json.decode(repositories.message.data));
          orderHistory.value = dataOrderHistoryMFromJson(json.encode(data['orders']));
        }

        switch (tabIndex) {
          case 0:
            refreshControllerPending.refreshCompleted();
            break;
          case 1:
            refreshControllerProcessing.refreshCompleted();
            break;
          case 2:
            refreshControllerDelivered.refreshCompleted();
            break;
        }
        update(); // Trigger UI update
      } else {
        switch (tabIndex) {
          case 0:
            refreshControllerPending.refreshFailed();
            break;
          case 1:
            refreshControllerProcessing.refreshFailed();
            break;
          case 2:
            refreshControllerDelivered.refreshFailed();
            break;
        }
      }
    } catch (e) {
      switch (tabIndex) {
        case 0:
          refreshControllerPending.refreshFailed();
          break;
        case 1:
          refreshControllerProcessing.refreshFailed();
          break;
        case 2:
          refreshControllerDelivered.refreshFailed();
          break;
      }
    }
  }



  /// ✅ تحديث `getListOfLoading` ليعمل لكل `Tab` بشكل منفصل
  Future<void> getListOfLoading(int tabIndex) async {
    try {
      OrderHistoryRepositories repositories = OrderHistoryRepositories();
      Map<String, String> body = {
        'perPage': '10',
        'status': orderHistoryStatus.name,
        'page': page.toString(),
      };

      if (await repositories.display_orders(bodyData: body)) {
        RxList<OrderModel> orderHistoryNew = <OrderModel>[].obs;
        if (repositories.message.data != null) {
          var data = json.decode(json.decode(repositories.message.data));
          orderHistoryNew.value = dataOrderHistoryMFromJson(json.encode(data['orders']));
        }

        if (orderHistoryNew.isEmpty) {
          empty = true;
          switch (tabIndex) {
            case 0:
              refreshControllerPending.loadComplete();
              break;
            case 1:
              refreshControllerProcessing.loadComplete();
              break;
            case 2:
              refreshControllerDelivered.loadComplete();
              break;
          }
        } else {
          orderHistory.addAll(orderHistoryNew);
          switch (tabIndex) {
            case 0:
              refreshControllerPending.loadComplete();
              break;
            case 1:
              refreshControllerProcessing.loadComplete();
              break;
            case 2:
              refreshControllerDelivered.loadComplete();
              break;
          }
          update(); // Trigger UI update
          page++;
        }
      } else {
        switch (tabIndex) {
          case 0:
            refreshControllerPending.loadFailed();
            break;
          case 1:
            refreshControllerProcessing.loadFailed();
            break;
          case 2:
            refreshControllerDelivered.loadFailed();
            break;
        }
      }
    } catch (e) {
      switch (tabIndex) {
        case 0:
          refreshControllerPending.loadFailed();
          break;
        case 1:
          refreshControllerProcessing.loadFailed();
          break;
        case 2:
          refreshControllerDelivered.loadFailed();
          break;
      }
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
    initWebSocket();
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