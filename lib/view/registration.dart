import 'dart:developer';

import 'package:firebase_practice_app/consts/color.dart';
import 'package:firebase_practice_app/consts/routes.dart';
import 'package:firebase_practice_app/controllers/auth_controller.dart';
import 'package:firebase_practice_app/models/user_moder.dart';
import 'package:firebase_practice_app/services/auth_service.dart';
import 'package:firebase_practice_app/widgets/toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});
  final AuthController authController = Get.find<AuthController>();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Obx(() => Text(
              authController.isRegistrationScreen.value ? "Sign In" : "Log In",
              style: const TextStyle(color: secondaryColor),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ToggleWidget(
                  firstButtonPressed: () {
                    authController.isRegistrationScreen.value = true;
                    authController.regEmailTextEditingController.clear();
                    authController.regNameTextEditingController.clear();
                    authController.regPasswordTextEditingController.clear();
                  },
                  secondButtonPressed: () {
                    authController.isRegistrationScreen.value = false;
                    authController.regEmailTextEditingController.clear();
                    authController.regNameTextEditingController.clear();
                    authController.regPasswordTextEditingController.clear();
                  },
                  isFirstButtonToggled: authController.isRegistrationScreen.value,
                ),
                if (authController.isRegistrationScreen.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: authController.regNameTextEditingController,
                      decoration: const InputDecoration(hintText: "Name"),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Email"),
                  controller: authController.regEmailTextEditingController,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Password"),
                  controller: authController.regPasswordTextEditingController,
                ),
                if (authController.isRegistrationScreen.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primaryColor),
                        ),
                        onPressed: () async {
                          Users result = await authService.registerWithEmailAndPassword(authController.regEmailTextEditingController.text,
                              authController.regPasswordTextEditingController.text, authController.regNameTextEditingController.text);
                          // if (result != null) {
                          log(result.uid.toString());
                          // }
                          authController.isRegistrationScreen.value = false;
                          authController.regEmailTextEditingController.clear();
                          authController.regNameTextEditingController.clear();
                          authController.regPasswordTextEditingController.clear();
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                if (!authController.isRegistrationScreen.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primaryColor),
                        ),
                        onPressed: () async {
                          Users result = await authService.signInWithEmailAndPassword(
                              authController.regEmailTextEditingController.text, authController.regPasswordTextEditingController.text);
                          log(result.uid.toString());
                          authController.regEmailTextEditingController.clear();
                          authController.regNameTextEditingController.clear();
                          authController.regPasswordTextEditingController.clear();
                          Get.offAllNamed(krHome);
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(color: Colors.black),
                        )),
                  )
                // ElevatedButton(
                //     onPressed: () async {
                //       var result = await authService.signInAnonymous();
                //       if (result != null) {
                //         log(result.user.toString());
                //       }
                //     },
                //     child: const Text("Sign In Anonymously"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
