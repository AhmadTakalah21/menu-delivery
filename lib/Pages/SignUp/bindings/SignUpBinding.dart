import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/SignUp/Controllers/SignUpControllers.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUpControllers());
  }
}



