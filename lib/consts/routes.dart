import 'package:firebase_practice_app/view/home_screen.dart';
import 'package:firebase_practice_app/view/registration.dart';
import 'package:firebase_practice_app/view/splash_screen.dart';
import 'package:get/get.dart';

const String krSplash = '/';
const String krHome = '/home';
const String krRegistration = "/registration";

List<GetPage<dynamic>>? routes = [
  GetPage(name: krSplash, page: () => SplashScreen(), transition: Transition.noTransition),
  GetPage(name: krHome, page: () => HomeScreen(), transition: Transition.noTransition),
  GetPage(name: krRegistration, page: () => RegistrationScreen(), transition: Transition.noTransition),
];
