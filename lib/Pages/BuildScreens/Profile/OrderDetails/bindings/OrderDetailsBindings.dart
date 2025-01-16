










import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/Controllers/OrderDetailsControllers.dart';

class OrderDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderDetailsControllers());
  }
}



