import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(
          String collection, String document, Map<String, String> data) async =>
      await _firestore.collection(collection).doc(document).set(data);

  Future<void> deleteUserData(String collection, String document) async =>
      await _firestore.collection(collection).doc(document).delete();
}
