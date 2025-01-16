part of 'AppPages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const SingIn = _Paths.SingIn;
  static const SignUp = _Paths.SignUp;
  static const MAIN_SCREEN = _Paths.MAIN_SCREEN;
  static const CategoryDetails = _Paths.CategoryDetails;
  static const StoreItem = _Paths.StoreItem;
  static const BrandsDetails = _Paths.BrandsDetails;
  static const Withdrawal = _Paths.Withdrawal;
  static const OrderHistory = _Paths.OrderHistory;
  static const OrderDetails = _Paths.OrderDetails;
  static const Products = _Paths.Products;
  static const Notifications = _Paths.Notifications;
  static const ItemsDetails = _Paths.ItemsDetails;
  static const ItemsDetailsSlider = _Paths.ItemsDetailsSlider;


}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/SplashScreen';
  static const SingIn = '/SingIn';
  static const MAIN_SCREEN = '/mainScreen';
  static const CategoryDetails = '/CategoryDetails';
  static const StoreItem = '/StoreItem';
  static const BrandsDetails = '/BrandsDetails';
  static const Withdrawal = '/Withdrawal';
  static const OrderHistory = '/OrderHistory';
  static const OrderDetails = '/OrderDetails';
  static const Products = '/Products';
  static const Notifications = '/Notifications';
  static const SignUp = '/SignUp';
  static const ItemsDetails = '/ItemsDetails';
  static const ItemsDetailsSlider = '/ItemsDetailsSlider';

}
