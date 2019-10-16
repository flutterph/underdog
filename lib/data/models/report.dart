import 'package:floor/floor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@entity
class Report {
  @primaryKey
  int id;
  int reporterId;
  String codeName;
  String breed;
  double latitude;
  double longitude;
  String landmark;
  String additionalInfo;
}
