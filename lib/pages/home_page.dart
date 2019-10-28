import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/camera_positions.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/data/models/user_location.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/reports_page.dart';
import 'package:underdog/pages/submit_report_page.dart';
import 'package:underdog/pages/view_report_page.dart';
import 'package:underdog/viewmodels/home_app_bar.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/widgets/home_drawer.dart';
import 'package:underdog/widgets/report_preview.dart';

import '../service_locator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final double _zoom = 16;

  Timer _locationUpdateTimer;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId _userMarkerId = MarkerId('userMarkerId');
  HomeModel _homeModel = locator<HomeModel>();

  // Animation variables
  AnimationController _appBarAnimationController;
  Animation _appBarAnimation;

  AnimationController _bottomBarAnimationController;
  Animation _bottomBarAnimation;

  @override
  void initState() {
    super.initState();

    // Animations
    _appBarAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _appBarAnimation = Tween<Offset>(begin: Offset(0, -128), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _appBarAnimationController, curve: Curves.fastOutSlowIn));

    _bottomBarAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _bottomBarAnimation =
        Tween<Offset>(begin: Offset(0, 128), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _bottomBarAnimationController,
                curve: Curves.fastOutSlowIn));

    _appBarAnimationController.forward();
    _bottomBarAnimationController.forward();

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
      builder: (context) => _homeModel,
      child: Consumer<HomeModel>(
        child: HomeAppBar(),
        builder: (context, model, consumerChild) {
          return Stack(
            children: <Widget>[
              Scaffold(
                drawer: HomeDrawer(),
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPositions.taguig,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        _locationUpdateTimer = Timer.periodic(
                            Duration(seconds: 3), _updateUserMarker);
                        _initializeUserMarker();
                        _animateToUserLocation();
                      },
                      markers: Set<Marker>.of(markers.values),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedBuilder(
                          animation: _appBarAnimation,
                          child: consumerChild,
                          builder: (context, animatedChild) {
                            return Transform.translate(
                              offset: _appBarAnimation.value,
                              child: animatedChild,
                            );
                          }),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedBuilder(
                          animation: _bottomBarAnimation,
                          child: Card(
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  AnimatedSize(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn,
                                    vsync: this,
                                    child: Column(
                                      children: <Widget>[
                                        (model.selectedReport == null)
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewReportPage(
                                                                report: model
                                                                    .selectedReport,
                                                              )));
                                                },
                                                child: ReportPreview(
                                                    report:
                                                        model.selectedReport)),
                                        (model.selectedReport == null)
                                            ? Container()
                                            : Divider(
                                                height: 2,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Builder(
                                        builder: (context) => IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.list,
                                              color:
                                                  Theme.of(context).accentColor,
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
                          builder: (context, animatedChild) {
                            return Transform.translate(
                              offset: _bottomBarAnimation.value,
                              child: animatedChild,
                            );
                          }),
                    )
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 56),
                  child: FloatingActionButton(
                    child: Icon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: _animateToUserLocation,
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

    // Animate Maps camera if a report has been selected
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

    // Update markers if a new report was successfully submitted
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

    if (!_homeModel.hasAnimatedToCurrentLocation) {
      _animateToUserLocation();
      _homeModel.hasAnimatedToCurrentLocation = true;
    }

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
    final reports = await _homeModel.getReports();

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
        onTap: () {
          _homeModel.selectReport(report);
        },
      );

      setState(() {
        markers[markerId] = marker;
      });
    });
  }
}
