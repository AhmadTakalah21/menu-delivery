import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/SignIn/Controllers/SingInControllers.dart';

class SingInBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SingInControllers());
  }
}



