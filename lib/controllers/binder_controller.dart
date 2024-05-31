import 'package:firebase_practice_app/controllers/auth_controller.dart';
import 'package:firebase_practice_app/controllers/home_controller.dart';
import 'package:firebase_practice_app/controllers/splash_controller.dart';
import 'package:get/get.dart';

class BinderController implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashScreenController>(SplashScreenController());
    Get.put<AuthController>(AuthController());
    Get.put<HomeController>(HomeController());
  }
}
