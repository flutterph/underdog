import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/data/models/report.dart';

class ReportsDatabaseService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('report');

  DatabaseReference get databaseReference => _databaseReference;

  ReportsDatabaseService() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  Future<void> addReport(Report r) async {
    await _databaseReference.push().set(r.toMap());
  }

  Future<void> deleteReport(Report r) async {
    await _databaseReference.child(r.uid).set(null);
  }
}
