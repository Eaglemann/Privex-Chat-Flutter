import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  User? _user;

  User? get user {
    return _user;
  }
  AuthService();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }
}
