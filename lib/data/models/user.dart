import 'package:floor/floor.dart';

@entity
class User {
  @primaryKey
  int id;
  String firstName;
  String lastName;
  String address;
  int birthdate;
}
