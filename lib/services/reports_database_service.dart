import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/data/models/report.dart';

class ReportsDatabaseService {
  ReportsDatabaseService() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('reports');

  DatabaseReference get databaseReference => _databaseReference;

  Future<void> addReport(Report r) async {
    await _databaseReference.push().set(r.toMap());
  }

  Future<void> deleteReport(Report r) async {
    await _databaseReference.child(r.uid).remove();
  }

  Future<void> updateReport(Report r) async {
    await _databaseReference.child(r.uid).set(r.toMap());
  }

  Future<void> updateReportToRescued(String uid, bool isRescued) async {
    await _databaseReference.child(uid).child('is_rescued').set(isRescued);
  }

  Query getRescued() {
    return _databaseReference.orderByChild('is_rescued').equalTo(true);
  }

  Query getUnrescued() {
    return _databaseReference.orderByChild('is_rescued').equalTo(false);
  }
}
