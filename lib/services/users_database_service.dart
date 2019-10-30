import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/data/models/rescue.dart';
import 'package:underdog/data/models/user.dart';

class UsersDatabaseService {
  UsersDatabaseService() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('users');

  DatabaseReference get databaseReference => _databaseReference;

  Future<void> addUser(User r) async {
    await _databaseReference.push().set(r.toMap());
  }

  Future<User> getUserByRescuerId(String id) async {
    return User.fromSnapshot(await _databaseReference.child(id).once());
  }

  Future<void> deleteUser(User r) async {
    await _databaseReference.child(r.uid).remove();
  }

  Future<void> updateRescue(Rescue r) async {
    await _databaseReference.child(r.uid).set(r.toMap());
  }
}
