import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/user_location.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({Key key}) : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  Completer<GoogleMapController> _controller = Completer();
  double _zoom = 16;
  final _markerSize = 44.0;

  final CameraPosition _rizalMonument = CameraPosition(
    target: LatLng(14.5818, 120.9770),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _rizalMonument,
            onCameraIdle: _getLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _animateToUserLocation();
            },
          ),
          IgnorePointer(
              child: Center(
            child: Transform.translate(
              offset: Offset(0, -_markerSize / 2),
              child: Image.asset(
                'assets/marker.png',
                height: _markerSize,
              ),
            ),
          ))
        ],
      ),
    );
  }

  void _animateToUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final CameraPosition newPosition = CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: _zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void _getLocation() {}
}
