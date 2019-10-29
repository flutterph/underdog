import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/services/reports_database_service.dart';

import '../service_locator.dart';

class ReportsModel {
  final ReportsDatabaseService _reportsDatabaseService =
      locator<ReportsDatabaseService>();

  DatabaseReference getReports() {
    return _reportsDatabaseService.databaseReference;
  }

  Query getUnrescued() {
    return _reportsDatabaseService.getRescued();
  }
}
