import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice_app/consts/routes.dart';
import 'package:firebase_practice_app/controllers/home_controller.dart';
import 'package:firebase_practice_app/controllers/splash_controller.dart';
import 'package:firebase_practice_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final AuthService authService = AuthService();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () async {
                Get.find<SplashScreenController>().stopUpdatingLastSeen();
                await authService.logOut();
                Get.offAllNamed(krRegistration);
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('user_status').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              // DateTime dateTime = data['lastSeen'].toDate();

              // Format the DateTime
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(homeController.checkUserActive(data['lastSeen']) ? "Active" : "Inactive"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
