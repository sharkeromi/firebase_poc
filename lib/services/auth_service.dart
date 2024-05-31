import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice_app/controllers/splash_controller.dart';
import 'package:firebase_practice_app/models/user_moder.dart';
import 'package:firebase_practice_app/services/database_service.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Users? userFromFirebaseUser(User? user) {
    if (user != null) {
      log(user.uid.toString());
    }
    return user != null ? Users(uid: user.uid) : null;
  }

  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      User? user = userCredential.user;
      return userFromFirebaseUser(user);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      // create a new document for the user with uid
      await DatabaseService(uid: user?.uid).createUserData(name);
      return userFromFirebaseUser(user);
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        return "Weak Password";
      } else {
        return ex.code;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      Get.find<SplashScreenController>().startUpdatingLastSeen();
      return userFromFirebaseUser(user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Stream<Users?> get user {
    return auth.authStateChanges().map(userFromFirebaseUser);
  }

  Future<dynamic> logOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String> getUserName(String uid) async {
    String name = "";
    final userSnapshot = fireStore.collection('users').doc(uid);
    await userSnapshot.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        name = data['name'];
      },
      onError: (e) => log("Error getting document: $e"),
    );
    return name;
  }
}
