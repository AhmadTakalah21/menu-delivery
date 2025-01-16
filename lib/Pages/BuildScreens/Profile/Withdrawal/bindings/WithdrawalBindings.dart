








import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Withdrawal/Controllers/WithdrawalControllers.dart';

class WithdrawalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(WithdrawalControllers());
  }
}



