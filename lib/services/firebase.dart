import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:swift_chat/app/app.locator.dart';
import 'package:swift_chat/services/auth.dart';
import 'package:swift_chat/services/firestore.dart';
import 'package:swift_chat/utils/functions.dart';

class FirebaseService {
  final _authService = locator<AuthService>();
  final _firestoreService = locator<FireStoreService>();
  final _firebaseStorage = FirebaseStorage.instance;

  Future<String?> register(
    String name,
    String email,
    String password,
    File file,
  ) async {
    return await tryCatch(() async {
      final error =
          await _authService.createUserWithEmailAndPassword(email, password);

      if (error != null) return error;

      final ref = _firebaseStorage
          .ref()
          .child('user-images')
          .child('${_authService.user!.uid}.jpg');

      await ref.putData(await file.readAsBytes());

      final imageUrl = await ref.getDownloadURL();

      await _firestoreService.saveUserData('users', _authService.user!.uid, {
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      });
    }).then((error) async {
      if (error != null) return error;
      return null;
    });
  }

  Future<String?> login(
    String email,
    String password,
  ) async {
    return await tryCatch(() async {
      final error =
          await _authService.signInUserWithEmailAndPassword(email, password);
      if (error != null) return error;
      return null;
    }).then((error) async {
      return error;
    });
  }

  Future<String?> resetPassword(
    String email,
  ) async {
    return await tryCatch(() async {
      final error = await _authService.resetPassword(email);
      if (error != null) return error;
      return null;
    }).then((error) async {
      return error;
    });
  }
}
