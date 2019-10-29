import 'package:firebase_database/firebase_database.dart';

class User {
  User(
      {this.uid,
      this.email,
      this.displayPhotoUrl,
      this.firstName,
      this.lastName,
      this.address,
      this.birthdate,
      this.type});

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
        email: map['email'],
        displayPhotoUrl: map['display_photo_url'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        address: map['address'],
        birthdate: map['birthdate'],
        type: map['type']);
  }

  factory User.fromSnapshot(DataSnapshot snapshot) {
    final User user = User(
        email: snapshot.value['email'],
        displayPhotoUrl: snapshot.value['display_photo_url'],
        firstName: snapshot.value['first_name'],
        lastName: snapshot.value['last_name'],
        address: snapshot.value['address'],
        birthdate: snapshot.value['birthdate'],
        type: snapshot.value['type']);

    user.uid = snapshot.key;

    return user;
  }

  String uid;
  String email;
  String displayPhotoUrl;
  String firstName;
  String lastName;
  String address;
  String birthdate;
  String type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'display_photo_url': displayPhotoUrl,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'birthdate': birthdate,
      'type': type
    };
  }
}
