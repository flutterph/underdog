import 'package:firebase_database/firebase_database.dart';

class Report {
  Report(
      this.reporterId,
      this.rescuerId,
      this.isRescued,
      this.codeName,
      this.imageUrl,
      this.breed,
      this.address,
      this.latitude,
      this.longitude,
      this.additionalInfo,
      this.date);

  factory Report.fromMap(Map<dynamic, dynamic> map) {
    return Report(
      map['reporter_id'],
      map['rescuer_id'],
      map['is_rescued'],
      map['code_name'],
      map['image_url'],
      map['breed'],
      map['address'],
      map['latitude'],
      map['longitude'],
      map['additional_info'],
      map['date'],
    );
  }

  factory Report.fromSnapshot(DataSnapshot snapshot) {
    final Report report = Report(
      snapshot.value['reporter_id'],
      snapshot.value['rescuer_id'],
      snapshot.value['is_rescued'],
      snapshot.value['code_name'],
      snapshot.value['image_url'],
      snapshot.value['breed'],
      snapshot.value['address'],
      snapshot.value['latitude'],
      snapshot.value['longitude'],
      snapshot.value['additional_info'],
      snapshot.value['date'],
    );

    report.uid = snapshot.key;

    return report;
  }

  String uid;
  String reporterId;
  String rescuerId;

  bool isRescued;
  String codeName;
  String imageUrl;
  String breed;
  String address;
  double latitude;
  double longitude;
  String additionalInfo;
  String date;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reporter_id': reporterId,
      'rescuer_id': rescuerId,
      'is_rescued': isRescued,
      'code_name': codeName,
      'image_url': imageUrl,
      'breed': breed,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'additional_info': additionalInfo,
      'date': date
    };
  }
}
