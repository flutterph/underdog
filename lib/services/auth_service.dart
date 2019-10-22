import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserId() async {
    return (await _auth.currentUser()).uid;
  }

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
      return mapErrorCodeToMessage(e.code);
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

  String mapErrorCodeToMessage(String code) {
    switch (code) {
      case 'ERROR_INVALID_EMAIL':
        return 'Please use a valid e-mail address';
        break;
      case 'ERROR_WRONG_PASSWORD':
        return 'You entered an incorrect password';
        break;
      case 'ERROR_USER_NOT_FOUND':
        return 'There is no user associated with those credentials';
        break;
      case 'ERROR_USER_DISABLED':
        return 'This user has been disabled by the administrator';
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'Too many incorrect attempts';
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return 'This user has been disabled by the administrators';
        break;
    }
  }
}
