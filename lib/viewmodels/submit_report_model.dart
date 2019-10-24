import 'dart:io';

import 'package:flutter/material.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:underdog/services/location_service.dart';
import 'package:underdog/services/reports_database_service.dart';
import 'package:underdog/services/storage_service.dart';

import '../service_locator.dart';

enum ViewState { Idle, Busy }

class SubmitReportModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  final StorageService _storageService = locator<StorageService>();
  final LocationService _locationService = locator<LocationService>();
  final ReportsDatabaseService _reportsDatabaseService =
      locator<ReportsDatabaseService>();

  // States
  String breed = 'Aspin';
  LocationInfo _locationInfo;

  SubmitReportModel() {
    getLocationInfoFromCurrentLocation();
  }

  Future<String> submitReport(
    File image,
    String codeName,
    String breed,
    String landmark,
    double latitude,
    double longitude,
    String additionalInfo,
  ) async {
    final imageUrl = await _storageService.uploadImage(image);
    if (imageUrl != null) {
      final newReport = Report(
          (await _authService.getUserId()),
          null,
          false,
          codeName,
          imageUrl,
          breed,
          landmark,
          latitude,
          longitude,
          additionalInfo,
          DateTime.now().toIso8601String());
      _reportsDatabaseService.addReport(newReport);

      return null;
    } else
      return 'Something went wrong while trying to submit your report. Please try again.';
  }

  Future<void> getLocationInfoFromCurrentLocation() async {
    _locationInfo = await _locationService.getLocationInfoFromCurrentLocation();
    notifyListeners();
  }

  updateLocationInfo(LocationInfo locationInfo) {
    _locationInfo = locationInfo;
    notifyListeners();
  }

  // Accessors
  LocationInfo get locationInfo => _locationInfo;
}
