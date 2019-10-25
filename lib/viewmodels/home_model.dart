import 'package:flutter/material.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:underdog/services/reports_database_service.dart';

import '../service_locator.dart';

class HomeModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  final ReportsDatabaseService _reportsDatabaseService =
      locator<ReportsDatabaseService>();

  bool hasAnimatedToCurrentLocation = false;
  Report selectedReport;
  List<Report> _reports;

  Future<bool> logout() async {
    return _authService.logout();
  }

  Future<List<Report>> getReports() async {
    _reports = List<Report>();
    var snapshot = await _reportsDatabaseService.databaseReference.once();

    print('SNAPSHOT: ${snapshot.value}');

    Map<dynamic, dynamic> maps = snapshot.value;
    maps.forEach((key, value) {
      final report = Report.fromMap(maps[key]);
      report.uid = key;
      _reports.add(report);
    });
    return _reports;
  }

  void selectReport(Report report) {
    if (report == null)
      print('null boi');
    else
      print(report.uid);
    selectedReport = report;
    notifyListeners();
  }

  void clearSelectedReport() {
    selectedReport = null;
    notifyListeners();
  }
}
