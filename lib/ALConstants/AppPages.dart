
import 'package:get/get.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/BrandsDetails/Views/BrandsDetails.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/BrandsDetails/bindings/OffersItemBindings.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/ItemsDetails/Views/ItemsDetails.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Brands/ItemsDetails/bindings/ItemsDetailsBindings.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/CategoryDetails/Views/CategoryDetails.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/CategoryDetails/bindings/CategoryDetailsBindings.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/StoreItem/Views/StoreItem.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Home/StoreItem/bindings/StoreItemBindings.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/Views/OrderDetails.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderDetails/bindings/OrderDetailsBindings.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/Views/OrderHistory.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/OrderHistory/bindings/OrderHistoryBindings.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Products/Views/Products.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Products/bindings/ProductsBindings.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Withdrawal/Views/Withdrawal.dart';
import 'package:shopping_land_delivery/Pages/BuildScreens/Profile/Withdrawal/bindings/WithdrawalBindings.dart';
import 'package:shopping_land_delivery/Pages/MainScreenView/Views/MainScreenView.dart';
import 'package:shopping_land_delivery/Pages/MainScreenView/bindings/MainScreenViewBinding.dart';
import 'package:shopping_land_delivery/Pages/SignIn/Views/SingIn.dart';
import 'package:shopping_land_delivery/Pages/SignIn/bindings/SingInBinding.dart';
import 'package:shopping_land_delivery/Pages/SignUp/Views/SignUp.dart';
import 'package:shopping_land_delivery/Pages/SignUp/bindings/SignUpBinding.dart';
import 'package:shopping_land_delivery/Pages/SplashScreen/Views/SplashScreen.dart';

part 'AppRoutes.dart';

class AppPages {
  AppPages._();

  static final routes = [

  GetPage(
      name: _Paths.SPLASH,
      page: () =>   SplashScreen(),
      showCupertinoParallax: true,
      transition: Transition.fadeIn,
    ),

  GetPage(
      name: _Paths.SingIn,
      page: () =>   SingIn(),
      binding: SingInBinding(),
      showCupertinoParallax: true,
      transition: Transition.rightToLeft,
    ),


    GetPage(
      name: _Paths.SignUp,
      page: () =>   SignUp(),
      binding: SignUpBinding(),
      showCupertinoParallax: true,
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: _Paths.MAIN_SCREEN,
      page: () =>  MainScreenView(),
      binding: MainScreenViewBinding(),
    ),


    GetPage(
      name: _Paths.CategoryDetails,
      page: () =>  CategoryDetails(),
      binding: CategoryDetailsBindings(),
      transition:Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.StoreItem,
      page: () =>  StoreItem(),
      binding: StoreItemBindings(),
      transition:Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.BrandsDetails,
      page: () =>  BrandsDetails(),
      binding: BrandsDetailsBindings(),
      transition:Transition.rightToLeft,
    ),

    GetPage(
      name: _Paths.Withdrawal,
      page: () =>  Withdrawal(),
      binding: WithdrawalBindings(),
      transition:Transition.rightToLeft,
    ),

    GetPage(
      name: _Paths.OrderHistory,
      page: () =>  OrderHistory(),
      binding: OrderHistoryBindings(),
      transition:Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.OrderDetails,
      page: () =>  OrderDetails(),
      binding:OrderDetailsBindings(),
      transition:Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.Products,
      page: () =>  Products(),
      binding:ProductsBindings(),
      transition:Transition.rightToLeft,
    ),

    GetPage(
      name: _Paths.ItemsDetails,
      page: () =>  ItemsDetails(),
      binding:ItemsDetailsBindings(),
      transition:Transition.rightToLeft,
    ),


  ];

  }