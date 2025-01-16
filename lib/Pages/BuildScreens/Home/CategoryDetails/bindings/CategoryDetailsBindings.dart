



import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/CategoryDetails/Controllers/CategoryDetailsControllers.dart';

class CategoryDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(CategoryDetailsControllers());
  }
}



