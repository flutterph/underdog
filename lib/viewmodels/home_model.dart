import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/data/models/stats.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:underdog/services/pref_service.dart';
import 'package:underdog/services/reports_database_service.dart';

import '../service_locator.dart';

class HomeModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  final ReportsDatabaseService _reportsDatabaseService =
      locator<ReportsDatabaseService>();
  final PrefService _prefService = locator<PrefService>();

  bool hasAnimatedToCurrentLocation = false;
  Report _selectedReport;
  List<Report> _reports;
  Stats _stats;

  Report get selectedReport => _selectedReport;
  List<Report> get reports => _reports;
  Stats get stats => _stats;

  Future<bool> logout() async {
    await _prefService.clearUserPrefs();
    return _authService.logout();
  }

  Future<List<Report>> getReports() async {
    _reports = <Report>[];
    final DataSnapshot snapshot =
        await _reportsDatabaseService.databaseReference.once();

    print('SNAPSHOT: ${snapshot.value}');

    final Map<dynamic, dynamic> maps = snapshot.value;
    maps.forEach((dynamic key, dynamic value) {
      final Report report = Report.fromMap(maps[key]);
      report.uid = key;
      _reports.add(report);
    });
    return _reports;
  }

  Future<List<Report>> getUnrescuedReports() async {
    _reports = <Report>[];
    final DataSnapshot snapshot =
        await _reportsDatabaseService.getUnrescued().once();

    print('SNAPSHOT: ${snapshot.value}');

    final Map<dynamic, dynamic> maps = snapshot.value;
    maps.forEach((dynamic key, dynamic value) {
      final Report report = Report.fromMap(maps[key]);
      report.uid = key;
      _reports.add(report);
    });
    return _reports;
  }

  Stream<Stats> watchStats() {
    return _reportsDatabaseService.watchStats();
  }

  void selectReport(Report report) {
    if (report == null)
      print('null boi');
    else
      print(report.uid);
    _selectedReport = report;
    notifyListeners();
  }

  void clearSelectedReport() {
    _selectedReport = null;
    notifyListeners();
  }
}
