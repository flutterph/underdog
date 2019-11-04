import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/data/models/stats.dart';

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

  Future<Stats> getStats() async {
    final Map<dynamic, dynamic> reportsMap =
        (await getUnrescued().once()).value;
    final Map<dynamic, dynamic> rescuesMap = (await getRescued().once()).value;

    return Stats(reportsMap.length, rescuesMap.length);
  }

  Query getRescued() {
    return _databaseReference.orderByChild('is_rescued').equalTo(true);
  }

  Query getUnrescued() {
    return _databaseReference.orderByChild('is_rescued').equalTo(false);
  }
}
