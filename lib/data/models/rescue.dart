import 'package:firebase_database/firebase_database.dart';

class Rescue {
  Rescue(this.reportId, this.rescuerId, this.imageUrl, this.address,
      this.latitude, this.longitude, this.additionalInfo, this.date);

  factory Rescue.fromMap(Map<dynamic, dynamic> map) {
    return Rescue(
      map['report_id'],
      map['rescuer_id'],
      map['image_url'],
      map['address'],
      map['latitude'],
      map['longitude'],
      map['additional_info'],
      map['date'],
    );
  }

  factory Rescue.fromSnapshot(DataSnapshot snapshot) {
    final Rescue rescue = Rescue(
      snapshot.value['report_id'],
      snapshot.value['rescuer_id'],
      snapshot.value['image_url'],
      snapshot.value['address'],
      snapshot.value['latitude'],
      snapshot.value['longitude'],
      snapshot.value['additional_info'],
      snapshot.value['date'],
    );

    rescue.uid = snapshot.key;

    return rescue;
  }

  String uid;
  String reportId;
  String rescuerId;
  String imageUrl;
  String address;
  double latitude;
  double longitude;
  String additionalInfo;
  String date;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'report_id': reportId,
      'rescuer_id': rescuerId,
      'image_url': imageUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'additional_info': additionalInfo,
      'date': date
    };
  }
}
