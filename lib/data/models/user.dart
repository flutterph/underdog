// import 'package:floor/floor.dart';

// @entity
import 'package:firebase_database/firebase_database.dart';

class User {
  // @primaryKey
  String uid;
  String email;
  String firstName;
  String lastName;
  String address;
  String birthdate;

  User(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.address,
      this.birthdate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'birthdate': birthdate,
    };
  }

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
        email: map['email'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        address: map['address'],
        birthdate: map['birthdate']);
  }

  factory User.fromSnapshot(DataSnapshot snapshot) {
    final user = User(
      email: snapshot.value['email'],
      firstName: snapshot.value['first_name'],
      lastName: snapshot.value['last_name'],
      address: snapshot.value['address'],
      birthdate: snapshot.value['birthdate'],
    );

    user.uid = snapshot.key;

    return user;
  }
}
