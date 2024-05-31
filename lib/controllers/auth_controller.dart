import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final TextEditingController regEmailTextEditingController = TextEditingController();
  final TextEditingController regPasswordTextEditingController = TextEditingController();
  final TextEditingController regNameTextEditingController = TextEditingController();

  final TextEditingController logInEmailTextEditingController = TextEditingController();
  final TextEditingController logInPasswordTextEditingController = TextEditingController();

  final RxBool isRegistrationScreen = RxBool(true);
  final RxBool isLogInScreen = RxBool(false);
}
