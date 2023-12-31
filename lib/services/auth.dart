import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  User? user;
  final _auth = FirebaseAuth.instance;

  init() => user = _auth.currentUser;

  Future<void> logout() async {
    await _auth.signOut();
    user = null;
  }

  Future<void> deleteUser() async {
    await _auth.currentUser!.delete();
    user = null;
  }

  Future<String?> resetPassword(String email) async {
    return await authTryCatch(() async {
      await _auth.sendPasswordResetEmail(email: email);
    });
  }

  Future<String?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await authTryCatch(() async {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = credentials.user!;
    });
  }

  Future<String?> signInUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await authTryCatch(() async {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = credentials.user!;
    });
  }

  Stream<User?> authState() => _auth.userChanges();
}

Future<String?> authTryCatch(Future Function() callback) async {
  try {
    await callback();
  } on FirebaseAuthException catch (error) {
    if (error.code == 'INVALID_LOGIN_CREDENTIALS') {
      return 'Wrong email or password';
    }

    return error.message ?? 'There was problem while authenticating';
  } catch (error) {
    return 'There was an error. Please try again later';
  }
  return null;
}
