import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/user_location.dart';
import 'package:underdog/pages/reports_page.dart';
import 'package:underdog/widgets/superellipse_icon_button.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer _locationUpdateTimer;
  Completer<GoogleMapController> _controller = Completer();
  double _zoom = 16;

  static final CameraPosition _taguigLocation = CameraPosition(
    target: LatLng(14.5176, 121.0509),
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
            initialCameraPosition: _taguigLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _locationUpdateTimer =
                  Timer.periodic(Duration(seconds: 3), _updateUserPin);
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Underdog'),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SuperellipseIconButton(
                    color: Colors.amber,
                    iconData: Icons.report,
                    onTap: _navigateToReportsPage,
                  ),
                  SuperellipseIconButton(
                    color: Colors.amber,
                    iconData: Icons.add,
                    onTap: _navigateToReportsPage,
                  ),
                  SuperellipseIconButton(
                    color: Colors.amber,
                    iconData: Icons.help,
                    onTap: _navigateToReportsPage,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _navigateToReportsPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ReportsPage()));
  }

  // Called every 3 seconds by the location timer
  void _updateUserPin(Timer t) async {
    final GoogleMapController controller = await _controller.future;
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final CameraPosition newPosition = CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: _zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));

    print(
        'Updated user location to ${userLocation.latitude}, ${userLocation.longitude}');
  }
}
