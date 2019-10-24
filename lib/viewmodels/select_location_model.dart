import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/services/location_service.dart';

import '../service_locator.dart';

class SelectLocationModel extends ChangeNotifier {
  LocationService _locationService = locator<LocationService>();

  // States
  String _addressLine;
  CameraPosition _cameraPosition;
  LocationInfo _locationInfo;

  void getLocationInfoFromCameraPosition() async {
    _locationInfo = await _locationService
        .getLocationInfoFromCameraPosition(_cameraPosition);
    _addressLine = _locationInfo.addressLine;
    notifyListeners();
  }

  void getLocationInfoFromCurrentLocation() async {
    _locationInfo = await _locationService.getLocationInfoFromCurrentLocation();
  }

  void updateCameraPosition(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition;
  }

  // Getters
  String get addressLine => _addressLine;
  CameraPosition get cameraPosition => _cameraPosition;
  LocationInfo get locationInfo => _locationInfo;
}
