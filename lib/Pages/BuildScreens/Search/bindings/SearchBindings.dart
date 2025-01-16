










import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Search/Controllers/SearchControllers.dart';

class SearchBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchControllers());
  }
}



