import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/data/models/user.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/pref_service.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('users');

  User user;

  Future<String> getUserId() async {
    return (await _auth.currentUser()).uid;
  }

  Future<FirebaseUser> getFirebaseUser() async {
    return await _auth.currentUser();
  }

  Future<AuthStatus> checkAuthStatus() async {
    if ((await _auth.currentUser()) != null) {
      return AuthStatus.LOGGED_IN;
    }

    return AuthStatus.NOT_LOGGED_IN;
  }

  Future<String> login(String email, String password) async {
    try {
      final FirebaseUser firebaseUser = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      user = User.fromSnapshot(
          await _databaseReference.child(firebaseUser.uid).once());
      await locator<PrefService>().setUserPrefs(user);

      return null;
    } catch (e, s) {
      print(s);
      return mapErrorCodeToMessage(e.code);
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      user = null;

      return true;
    } catch (e) {
      return false;
    }
  }

  // TODO: Implement this using Cloud Functions in the future
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      final FirebaseUser firebaseUser = (await _auth
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      final User newUser = User()
        ..uid = firebaseUser.uid
        ..email = email
        ..firstName = firstName
        ..lastName = lastName
        ..type = 'normal';

      await _databaseReference.child(firebaseUser.uid).set(newUser.toMap());

      return null;
    } catch (e) {
      return mapErrorCodeToMessage(e.code);
    }
  }

  String mapErrorCodeToMessage(String code) {
    switch (code) {
      // Login error codes
      case 'ERROR_INVALID_EMAIL':
        return 'Please use a valid e-mail address';
        break;
      case 'ERROR_WRONG_PASSWORD':
        return 'You entered an incorrect password';
        break;
      case 'ERROR_USER_NOT_FOUND':
        return 'This account does not exist';
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

      // Register error codes
      case 'ERROR_WEAK_PASSWORD':
        return 'Please choose a more secure password';
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'Looks like that e-mail address is already in use';
        break;
    }

    return null;
  }
}
