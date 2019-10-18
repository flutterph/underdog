import 'package:floor/floor.dart';

@entity
class Report {
  @primaryKey
  int id;
  int reporterId;
  int rescuerId;

  bool isRescued;
  String codeName;
  String imageUrl;
  String breed;
  double latitude;
  double longitude;
  String landmark;
  String additionalInfo;

  Report(
      this.id,
      this.reporterId,
      this.rescuerId,
      this.isRescued,
      this.codeName,
      this.imageUrl,
      this.breed,
      this.landmark,
      this.latitude,
      this.longitude,
      this.additionalInfo);
}
