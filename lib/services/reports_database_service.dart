import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/data/models/report.dart';

class ReportsDatabaseService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('report');

  Future<void> addReport(Report r) async {
    await _databaseReference.push().set(<String, dynamic>{
      "reporter_id": r.reporterId,
      "rescuer_id": r.rescuerId,
      "is_rescued": r.isRescued,
      "code_name": r.codeName,
      "image_url": r.imageUrl,
      "breed": r.breed,
      "landmark": r.landmark,
      "latitude": r.latitude,
      "longitude": r.longitude,
      "additional_info": r.additionalInfo,
      "date": r.date
    });
  }
}
