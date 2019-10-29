import 'package:firebase_database/firebase_database.dart';
import 'package:underdog/services/reports_database_service.dart';

import '../service_locator.dart';

class RescuedReportsListModel {
  final ReportsDatabaseService _reportsDatabaseService =
      locator<ReportsDatabaseService>();

  Query getRescued() {
    return _reportsDatabaseService.getRescued();
  }
}
