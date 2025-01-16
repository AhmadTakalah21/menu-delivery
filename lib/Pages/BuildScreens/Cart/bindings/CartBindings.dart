




import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Cart/Controllers/CartControllers.dart';

class CartBindingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(CartControllers());
  }
}



