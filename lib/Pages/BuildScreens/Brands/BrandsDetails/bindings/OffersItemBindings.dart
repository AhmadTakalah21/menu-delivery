








import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/BrandsDetails/Controllers/BrandsDetailsControllers.dart';

class BrandsDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>BrandsDetailsControllers());
  }
}



