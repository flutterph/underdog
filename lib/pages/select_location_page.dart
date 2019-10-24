import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/user_location.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/viewmodels/select_location_model.dart';

import '../service_locator.dart';

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
    return ChangeNotifierProvider<SelectLocationModel>(
      builder: (context) => locator<SelectLocationModel>(),
      child: Consumer<SelectLocationModel>(
        builder: (context, model, child) {
          return Scaffold(
            extendBody: true,
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                      _initCameraPosition() ?? _rizalMonument,
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
                        borderRadius: BorderRadius.circular(16),
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
                            SizedBox(
                              height: 8,
                            ),
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
          );
        },
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

  CameraPosition _initCameraPosition() {
    final userLocation = Provider.of<UserLocation>(context);
    return CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: _zoom);
  }
}
