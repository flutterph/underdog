import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/data/models/user_location.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/login_page.dart';
import 'package:underdog/pages/reports_page.dart';
import 'package:underdog/pages/submit_report_page.dart';
import 'package:underdog/pages/view_report_page.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/widgets/report_preview.dart';

import '../service_locator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer _locationUpdateTimer;
  Completer<GoogleMapController> _controller = Completer();
  double _zoom = 16;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId _userMarkerId = MarkerId('userMarkerId');

  static final CameraPosition _taguigLocation = CameraPosition(
    target: LatLng(14.5176, 121.0509),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();

    _initializeReportsMarkers();
  }

  @override
  void dispose() {
    _locationUpdateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => locator<HomeModel>(),
      child: Consumer<HomeModel>(
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Scaffold(
                drawer: Drawer(
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.doorOpen),
                    onPressed: () {
                      model.logout().then((value) {
                        if (value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }
                      });
                    },
                  ),
                ),
                extendBody: true,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(
                          FontAwesomeIcons.hamburger,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0))),
                  centerTitle: true,
                  title: Hero(
                    tag: HeroTag.MAIN_TITLE,
                    child: Material(
                      child: Text(
                        'Underdog',
                        style: UnderdogTheme.pageTitle.copyWith(fontSize: 24),
                      ),
                    ),
                  ),
                ),
                body: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _taguigLocation,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _locationUpdateTimer =
                        Timer.periodic(Duration(seconds: 3), _updateUserMarker);
                    _initializeUserMarker();
                    _animateToUserLocation();
                  },
                  markers: Set<Marker>.of(markers.values),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(
                    FontAwesomeIcons.mapMarkerAlt,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: _animateToUserLocation,
                ),
                bottomNavigationBar: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        (model.selectedReport == null)
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewReportPage(
                                                report: model.selectedReport,
                                              )));
                                },
                                child: ReportPreview(
                                    report: model.selectedReport)),
                        (model.selectedReport == null)
                            ? Container()
                            : Divider(
                                height: 2,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Builder(
                              builder: (context) => IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.list,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onPressed: () {
                                    _navigateToReportsPage(model);
                                  }),
                            ),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.paperPlane,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: _navigateToSubmitReportPage,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToReportsPage(HomeModel model) {
    final result = Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ReportsPage()));

    result.then((report) {
      if (report != null) {
        model.selectReport(report as Report);
        _animateToLocation(
            LatLng((report as Report).latitude, (report as Report).longitude));
      }
    });
  }

  void _navigateToSubmitReportPage() {
    final result = Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SubmitReportPage()));

    result.then((value) {
      if (value != null) if ((value as bool) == true)
        _initializeReportsMarkers();
    });
  }

  void _initializeUserMarker() async {
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final Marker marker = Marker(
      markerId: _userMarkerId,
      position: LatLng(userLocation.latitude, userLocation.longitude),
      infoWindow: InfoWindow(title: 'You are here'),
      onTap: () {},
    );

    setState(() {
      markers[_userMarkerId] = marker;
    });

    print(
        'Initialized user location at ${userLocation.latitude}, ${userLocation.longitude}');
  }

  // Called every 3 seconds by the location timer
  void _updateUserMarker(Timer t) async {
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final Marker marker = Marker(
      markerId: _userMarkerId,
      position: LatLng(userLocation.latitude, userLocation.longitude),
      infoWindow: InfoWindow(title: 'You are here'),
      onTap: () {},
    );

    setState(() {
      markers[_userMarkerId] = marker;
    });

    print(
        'Updated user location to ${userLocation.latitude}, ${userLocation.longitude}');
  }

  void _animateToUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final CameraPosition newPosition = CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: _zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void _animateToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;

    final CameraPosition newPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: _zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void _initializeReportsMarkers() async {
    final HomeModel homeModel = locator<HomeModel>();
    final reports = await homeModel.getReports();

    ImageConfiguration imageConfig = ImageConfiguration(size: Size(48, 48));
    final icon = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/service-dog.png');

    reports.forEach((report) {
      final markerId = MarkerId(report.uid);
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(report.latitude, report.longitude),
        infoWindow: InfoWindow(title: report.codeName),
        icon: icon,
        onTap: () {},
      );

      setState(() {
        markers[markerId] = marker;
      });
    });
  }
}
