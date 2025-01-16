




import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Profile/Controllers/ProfileControllers.dart';

class CartBindingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileControllers());
  }
}



