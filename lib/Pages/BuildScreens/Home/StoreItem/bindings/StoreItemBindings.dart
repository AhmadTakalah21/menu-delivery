



import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/StoreItem/Controllers/StoreItemControllers.dart';

class StoreItemBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StoreItemControllers());
  }
}



