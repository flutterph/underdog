// import 'package:floor/floor.dart';

// @entity
class Report {
  // @primaryKey
  String reporterId;
  String rescuerId;

  bool isRescued;
  String codeName;
  String imageUrl;
  String breed;
  String landmark;
  double latitude;
  double longitude;
  String additionalInfo;
  String date;

  Report(
      this.reporterId,
      this.rescuerId,
      this.isRescued,
      this.codeName,
      this.imageUrl,
      this.breed,
      this.landmark,
      this.latitude,
      this.longitude,
      this.additionalInfo,
      this.date);
}
