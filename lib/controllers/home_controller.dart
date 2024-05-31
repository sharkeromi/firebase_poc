import 'dart:developer';

import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rx<DateTime?> currentTime = Rx<DateTime?>(null);
  final Rx<DateTime?> previousTime = Rx<DateTime?>(null);

  bool checkUserActive(timeStamp) {
    Duration difference;
    if (timeStamp.toDate() != null) {
      currentTime.value = timeStamp.toDate();
      difference = currentTime.value!.difference(DateTime.now());
    } else {
      previousTime.value = currentTime.value;
      difference = previousTime.value!.difference(DateTime.now());
    }
    log(difference.inSeconds.toString());
    if (difference.inSeconds < -30) {
      return false;
    } else {
      return true;
    }
  }

  dynamic checkNullOrStringNull(str) {
    if (str == null || str == 'null' || str == '' || str == 'NA') {
      return null;
    } else {
      return str;
    }
  }
}
