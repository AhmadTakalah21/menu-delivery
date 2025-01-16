












import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Products/Controllers/ProductsControllers.dart';

class ProductsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductsControllers());
  }
}



