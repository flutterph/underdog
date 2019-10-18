import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AuthStatus> checkAuthStatus() async {
    if ((await _auth.currentUser()) != null) {
      return AuthStatus.LOGGED_IN;
    }

    return AuthStatus.NOT_LOGGED_IN;
  }

  Future<String> login(String email, String password) async {
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      return null;
    } catch (e) {
      print(e.code);
      // switch (e.code) {
      //   case 'ERROR_INVALID_EMAIL':
      //     break;
      //   case 'ERROR_WRONG_PASSWORD':
      //     break;
      //   case 'ERROR_USER_NOT_FOUND':
      //     break;
      //   case 'ERROR_USER_DISABLED':
      //     break;
      //   case 'ERROR_TOO_MANY_REQUESTS':
      //     break;
      //   case 'ERROR_OPERATION_NOT_ALLOWED':
      //     break;
      // }

      return e.code;
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();

      return true;
    } catch (e) {
      return false;
    }
  }
}
