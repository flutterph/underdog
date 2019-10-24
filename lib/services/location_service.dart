import 'dart:async';

import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/data/models/user_location.dart';

class LocationService {
  UserLocation _currentLocation;
  var location = Location();

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _currentLocation = UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            );
            _locationController.add(_currentLocation);
          }
        });
      }
    });
  }

  Future<LocationInfo> getLocationInfoFromCurrentLocation() async {
    final List<Address> address = await Geocoder.local
        .findAddressesFromCoordinates(
            Coordinates(_currentLocation.latitude, _currentLocation.longitude));
    final addressLine = address.first.addressLine;

    return LocationInfo(
        addressLine, _currentLocation.latitude, _currentLocation.longitude);
  }

  Future<LocationInfo> getLocationInfoFromCameraPosition(
      CameraPosition cameraPosition) async {
    final latLng = cameraPosition.target;
    final List<Address> address = await Geocoder.local
        .findAddressesFromCoordinates(
            Coordinates(latLng.latitude, latLng.longitude));
    final addressLine = address.first.addressLine;

    return LocationInfo(addressLine, latLng.latitude, latLng.longitude);
  }
}
