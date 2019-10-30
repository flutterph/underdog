import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/data/models/rescue.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:underdog/services/location_service.dart';
import 'package:underdog/services/reports_database_service.dart';
import 'package:underdog/services/rescues_database_service.dart';
import 'package:underdog/services/storage_service.dart';

import '../service_locator.dart';

enum PageState { Idle, Busy }

class SubmitRescueModel extends ChangeNotifier {
  SubmitRescueModel() {
    getLocationInfoFromCurrentLocation();
  }

  final AuthService _authService = locator<AuthService>();
  final StorageService _storageService = locator<StorageService>();
  final LocationService _locationService = locator<LocationService>();
  final ReportsDatabaseService _reportsDatabaseService =
      locator<ReportsDatabaseService>();
  final RescuesDatabaseService _rescuesDatabaseService =
      locator<RescuesDatabaseService>();

  PageState _state = PageState.Idle;
  LocationInfo _locationInfo;

  void setState(PageState state) {
    _state = state;
    notifyListeners();
  }

  Future<String> submitRescue(
    String reportId,
    File image,
    String address,
    double latitude,
    double longitude,
    String additionalInfo,
  ) async {
    setState(PageState.Busy);
    final String imageUrl = await _storageService.uploadImage(image);
    if (imageUrl != null) {
      final Rescue newRescue = Rescue(
          reportId,
          await _authService.getUserId(),
          imageUrl,
          address,
          latitude,
          longitude,
          additionalInfo,
          DateTime.now().toIso8601String());
      await _reportsDatabaseService.updateReportToRescued(reportId, true);
      await _rescuesDatabaseService.addRescue(newRescue);

      setState(PageState.Idle);
      return null;
    } else {
      setState(PageState.Idle);
      return 'Something went wrong while trying to submit your report. Please try again.';
    }
  }

  Future<void> getLocationInfoFromCurrentLocation() async {
    _locationInfo = await _locationService.getLocationInfoFromCurrentLocation();
    notifyListeners();
  }

  void updateLocationInfo(LocationInfo locationInfo) {
    _locationInfo = locationInfo;
    notifyListeners();
  }

  // Accessors
  LocationInfo get locationInfo => _locationInfo;
  PageState get state => _state;
}
