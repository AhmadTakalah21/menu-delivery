








import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/ItemsDetails/Controllers/ItemsDetailsControllers.dart';

class ItemsDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>ItemsDetailsControllers());
  }
}



