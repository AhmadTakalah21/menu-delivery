










import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Controllers/OrderHistoryControllers.dart';

class OrderHistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderHistoryControllers());
  }
}



