import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/consts/routes.dart';
import 'package:firebase_practice_app/services/auth_service.dart';
import 'package:firebase_practice_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController with WidgetsBindingObserver {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseService databaseService = DatabaseService();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  Timer? lastSeenTimer;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    checkInternetConnectivity();
    startSplashScreen();
    super.onInit();
  }

  @override
  void onClose() async {
    WidgetsBinding.instance.removeObserver(this);
    stopUpdatingLastSeen();
    super.onClose();
  }

  Rx<ConnectivityResult> connectionStatus = Rx<ConnectivityResult>(ConnectivityResult.none);
  final Connectivity connectivity = Connectivity();
  Future<void> checkInternetConnectivity() async {
    await initConnectivity();
    connectivitySubscription = connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
      connectionStatus.value = result;
      if (connectionStatus.value == ConnectivityResult.none) {
        stopUpdatingLastSeen();
      }
    } on PlatformException catch (e) {
      log('Connectivity status error: $e');
    }
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus.value = result;
    if (connectionStatus.value == ConnectivityResult.none) {
      stopUpdatingLastSeen();
    } else {
      Get.offNamedUntil(krSplash, (route) => false);
      startSplashScreen();
      startUpdatingLastSeen();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      // log("hello");
      // DatabaseService(uid: user.uid, name: userName).updateUserStatusData('inactive');
    } else if (state == AppLifecycleState.resumed) {
      startUpdatingLastSeen();
    } else if (state == AppLifecycleState.paused) {
      log("bello");
      stopUpdatingLastSeen();
    }
  }

  late Timer timer;

  Timer startSplashScreen() {
    var duration = const Duration(seconds: 3);
    timer = Timer(
      duration,
      () async {
        final user = auth.currentUser;
        log("HELLO: ${user}");
        if (user != null) {
          log(user.email.toString());
          auth.authStateChanges().listen((User? user) {
            startUpdatingLastSeen();
          });
          Get.offAllNamed(krHome);
        } else {
          Get.offAllNamed(krRegistration);
        }
      },
    );
    return timer;
  }

  void startUpdatingLastSeen() async {
    final user = auth.currentUser;
    var userName = await AuthService().getUserName(user!.uid);
    lastSeenTimer = Timer.periodic(const Duration(seconds: 30), (Timer t) => DatabaseService(uid: user.uid, name: userName).updateUserStatusData());
  }

  void stopUpdatingLastSeen() {
    lastSeenTimer?.cancel();
  }
}
