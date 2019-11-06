import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/user_location.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/viewmodels/select_location_model.dart';

import '../camera_positions.dart';
import '../service_locator.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({Key key}) : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final double _zoom = 16;
  final double _markerSize = 44.0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectLocationModel>(
      builder: (BuildContext context) => locator<SelectLocationModel>(),
      child: Consumer<SelectLocationModel>(
        builder:
            (BuildContext context, SelectLocationModel model, Widget child) {
          return Scaffold(
            extendBody: true,
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                      _initCameraPosition() ?? CameraPositions.rizalMonument,
                  onCameraIdle: model.getLocationInfoFromCameraPosition,
                  onCameraMove: model.updateCameraPosition,
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
                )),
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.black12)),
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'SELECT LOCATION',
                              style: UnderdogTheme.labelStyle,
                            ),
                            const SizedBox(height: 8),
                            Text(model.addressLine ?? ''),
                          ],
                        )),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(FontAwesomeIcons.check),
              onPressed: () async {
                Navigator.pop(context, model.locationInfo);
              },
            ),
            //      floatingActionButton: Column(
            //   children: <Widget>[
            //     FloatingActionButton(
            //       child: Icon(FontAwesomeIcons.cross),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       mini: true,
            //     ),
            //     const SizedBox(
            //       height: 8,
            //     ),
            //     FloatingActionButton(
            //       child: Icon(FontAwesomeIcons.check),
            //       onPressed: () async {
            //         Navigator.pop(context, model.locationInfo);
            //       },
            //     ),
            //   ],
            // ),
          );
        },
      ),
    );
  }

  Future<void> _animateToUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    final UserLocation userLocation = Provider.of<UserLocation>(context);
    final CameraPosition newPosition = CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: _zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  CameraPosition _initCameraPosition() {
    final UserLocation userLocation = Provider.of<UserLocation>(context);
    return CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: _zoom);
  }
}
