import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:underdog/pages/splash_screen_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/location_service.dart';
import 'package:underdog/underdog_theme.dart';

import 'data/models/user_location.dart';

class UnderdogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        StreamProvider<UserLocation>(
          builder: (BuildContext context) =>
              locator<LocationService>().locationStream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Underdog',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: UnderdogTheme.mustard)),
            iconTheme: IconThemeData(color: UnderdogTheme.mustard),
            // cardColor: UnderdogTheme.dirtyWhite,
            // scaffoldBackgroundColor: UnderdogTheme.dirtyWhite,
            fontFamily: 'Lato',
            inputDecorationTheme:
                InputDecorationTheme(hintStyle: UnderdogTheme.hintText),
            primarySwatch: UnderdogTheme.tealMaterialColor,
            accentColor: UnderdogTheme.teal,
            cursorColor: UnderdogTheme.teal,
            buttonTheme: ButtonThemeData(
              buttonColor: UnderdogTheme.mustard,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.black12)),
            ),
            cardTheme: CardTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                foregroundColor: Colors.white,
                backgroundColor: UnderdogTheme.mustard,
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                shape: CircleBorder(side: BorderSide(color: Colors.black12)))),
        home: const SplashScreenPage(),
      ),
    );
  }
}
