import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/services/location_service.dart';

import '../service_locator.dart';

class SelectLocationModel extends ChangeNotifier {
  LocationService _locationService = locator<LocationService>();
  CameraPosition _cameraPosition;
  String addressLine;
  LocationInfo locationInfo;

  Future<void> getLocationInfoFromCameraPosition() async {
    locationInfo = await _locationService
        .getLocationInfoFromCameraPosition(_cameraPosition);
    addressLine = locationInfo.addressLine;
    notifyListeners();
  }

  Future<LocationInfo> getLocationInfoFromUserLocation() async {
    locationInfo = await _locationService.getLocationInfoFromUserLocation();
    return locationInfo;
  }

  void updateCameraPosition(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition;
  }
}
