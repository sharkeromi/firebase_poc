import 'package:firebase_practice_app/consts/color.dart';
import 'package:flutter/material.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({super.key, required this.isFirstButtonToggled, required this.firstButtonPressed, required this.secondButtonPressed});
  final bool isFirstButtonToggled;
  final Function() firstButtonPressed, secondButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 155,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: secondaryColor),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            InkWell(
              onTap: firstButtonPressed,
              child: Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: isFirstButtonToggled ? primaryColor : secondaryTintColor),
                child: Center(
                    child: Text(
                  "Sign Up",
                  style: TextStyle(color: isFirstButtonToggled ? secondaryColor : primaryColor),
                )),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: secondButtonPressed,
              child: Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: isFirstButtonToggled ? secondaryTintColor : primaryColor),
                child: Center(
                    child: Text(
                  "Log In",
                  style: TextStyle(color: isFirstButtonToggled ? primaryColor : secondaryColor),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
