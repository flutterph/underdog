import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/data/models/rescue.dart';

class RescuesDatabaseService {
  RescuesDatabaseService() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('rescues');

  DatabaseReference get databaseReference => _databaseReference;

  Future<void> addRescue(Rescue r) async {
    await _databaseReference.push().set(r.toMap());
  }

  Future<Rescue> getRescueByReportId(String id) async {
    final DataSnapshot snapshot = await _databaseReference
        .orderByChild('report_id')
        .equalTo(id)
        .limitToFirst(1)
        .once();

    final Map<dynamic, dynamic> map = snapshot.value;
    final String key = map.keys.first;
    final Map<dynamic, dynamic> dataMap = map[key];

    return Rescue.fromMap(dataMap);
  }

  Future<void> deleteRescue(Rescue r) async {
    await _databaseReference.child(r.uid).remove();
  }

  Future<void> updateRescue(Rescue r) async {
    await _databaseReference.child(r.uid).set(r.toMap());
  }
}
