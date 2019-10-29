import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/camera_positions.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/data/models/user_location.dart';
import 'package:underdog/pages/reports_page.dart';
import 'package:underdog/pages/submit_report_page.dart';
import 'package:underdog/pages/view_report_page.dart';
import 'package:underdog/viewmodels/home_app_bar.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/widgets/home_drawer.dart';
import 'package:underdog/widgets/report_preview.dart';
import 'package:underdog/widgets/scale_page_route.dart';

import '../constants.dart';
import '../service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final double _zoom = 16;

  Timer _locationUpdateTimer;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final MarkerId _userMarkerId = MarkerId('userMarkerId');
  final HomeModel _homeModel = locator<HomeModel>();

  // Animation variables
  AnimationController _appBarAnimationController;
  Animation<Offset> _appBarAnimation;

  AnimationController _bottomBarAnimationController;
  Animation<Offset> _bottomBarAnimation;

  // AnimationController _fabAnimationController;
  // Animation _fabAnimation;

  @override
  void initState() {
    super.initState();

    // Animations
    _appBarAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _appBarAnimation =
        Tween<Offset>(begin: const Offset(0, -128), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _appBarAnimationController,
                curve: Curves.fastOutSlowIn));

    _bottomBarAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _bottomBarAnimation =
        Tween<Offset>(begin: const Offset(0, 256), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _bottomBarAnimationController,
                curve: Curves.fastOutSlowIn));

    // _fabAnimationController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));
    // _fabAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    //     parent: _bottomBarAnimationController, curve: Curves.fastOutSlowIn));

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
    return ChangeNotifierProvider<HomeModel>(
      builder: (BuildContext context) => _homeModel,
      child: Consumer<HomeModel>(
        child: const HomeAppBar(),
        builder: (BuildContext context, HomeModel model, Widget consumerChild) {
          return Stack(
            children: <Widget>[
              Scaffold(
                drawer: const HomeDrawer(),
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPositions.taguig,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        _locationUpdateTimer = Timer.periodic(
                            const Duration(seconds: 3), _updateUserMarker);
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
                          builder:
                              (BuildContext context, Widget animatedChild) {
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
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16.0, bottom: 16),
                                  child: FloatingActionButton(
                                    child: Icon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: _animateToUserLocation,
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black12),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16))),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      AnimatedSize(
                                        duration: const Duration(
                                            milliseconds: Constants
                                                .DEFAULT_ANIMATION_DURATION_MS),
                                        curve: Curves.fastOutSlowIn,
                                        vsync: this,
                                        child: Column(
                                          children: <Widget>[
                                            if (model.selectedReport == null)
                                              Container()
                                            else
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.push<dynamic>(
                                                        context,
                                                        MaterialPageRoute<
                                                                dynamic>(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                ViewReportPage(
                                                                  report: model
                                                                      .selectedReport,
                                                                )));
                                                  },
                                                  child: ReportPreview(
                                                      report: model
                                                          .selectedReport)),
                                            if (model.selectedReport == null)
                                              Container()
                                            else
                                              const Divider(height: 2),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Builder(
                                            builder: (BuildContext context) =>
                                                IconButton(
                                                    icon: Icon(
                                                      FontAwesomeIcons.listAlt,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    onPressed: () {
                                                      _navigateToReportsPage(
                                                          model);
                                                    }),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.fileAlt,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            onPressed:
                                                _navigateToSubmitReportPage,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          builder:
                              (BuildContext context, Widget animatedChild) {
                            return Transform.translate(
                              offset: _bottomBarAnimation.value,
                              child: animatedChild,
                            );
                          }),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToReportsPage(HomeModel model) {
    // final result = Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => ReportsPage()));
    final Future<Report> result = Navigator.of(context)
        .push(ScalePageRoute<Report>(page: const ReportsPage()));

    // Animate Maps camera if a report has been selected
    result.then((Report report) {
      if (report != null) {
        model.selectReport(report);
        _animateToLocation(LatLng(report.latitude, report.longitude));
      }
    });
  }

  void _navigateToSubmitReportPage() {
    // final result = Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => SubmitReportPage()));
    final Future<bool> result = Navigator.of(context)
        .push(ScalePageRoute<bool>(page: const SubmitReportPage()));

    // Update markers if a new report was successfully submitted
    result.then((bool value) {
      if (value != null && value == true) {
        _initializeReportsMarkers();
      }
    });
  }

  Future<void> _initializeUserMarker() async {
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final Marker marker = Marker(
      markerId: _userMarkerId,
      position: LatLng(userLocation.latitude, userLocation.longitude),
      infoWindow: const InfoWindow(title: 'You are here'),
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
  Future<void> _updateUserMarker(Timer t) async {
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final Marker marker = Marker(
      markerId: _userMarkerId,
      position: LatLng(userLocation.latitude, userLocation.longitude),
      infoWindow: const InfoWindow(title: 'You are here'),
      onTap: () {},
    );

    setState(() {
      markers[_userMarkerId] = marker;
    });

    print(
        'Updated user location to ${userLocation.latitude}, ${userLocation.longitude}');
  }

  Future<void> _animateToUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    final UserLocation userLocation = Provider.of<UserLocation>(context);

    final CameraPosition newPosition = CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: _zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  Future<void> _animateToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;

    final CameraPosition newPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: _zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  Future<void> _initializeReportsMarkers() async {
    final List<Report> reports = await _homeModel.getReports();

    const ImageConfiguration imageConfig =
        ImageConfiguration(size: Size(48, 48));
    final BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        imageConfig, 'assets/service-dog.png');

    for (Report report in reports) {
      final MarkerId markerId = MarkerId(report.uid);
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
    }
  }
}
