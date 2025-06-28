import 'package:get/get.dart';
import 'package:sync_day/controller/auth_controller.dart';
import 'package:sync_day/controller/common_controller.dart';
import 'package:sync_day/controller/dashboard_controller.dart';
import 'package:sync_day/controller/task_controller.dart';
import 'package:sync_day/pages/afterLogin/dashboard.dart';
import 'package:sync_day/pages/beforeLogin/login_screen.dart';
import 'package:sync_day/pages/splash_screen.dart';

class AppRoutes {
  static const initial = "/";
  static const dashboard = "/dashboard";
  static const login = "/login";
  static final routes = [
    GetPage(
      name: initial,
      page: () => SplashScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: dashboard,
      page: () => Dashboard(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder((){
        Get.put(CommonController());
        Get.put(DashboardController());
        Get.put(TaskController());
      }),
    ),

    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}
