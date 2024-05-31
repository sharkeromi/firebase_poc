import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  final String? name;
  DatabaseService({this.uid, this.name});

  //collection reference
  final CollectionReference brewsCollection = FirebaseFirestore.instance.collection('brews');

  Future<dynamic> updateUserData(String sugars, String name, int strength) async {
    return await brewsCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //user data
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<dynamic> createUserData(
    String name,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
    });
  }

  // user status data
  final CollectionReference userStatusCollection = FirebaseFirestore.instance.collection('user_status');

  Future<dynamic> updateUserStatusData() async {
    return await userStatusCollection.doc(uid).set({
      'name': name,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: false));
  }

  // get brews stream
  Stream<QuerySnapshot?> get brews {
    return brewsCollection.snapshots();
  }
}
