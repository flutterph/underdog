import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:underdog/pages/root_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/location_service.dart';
import 'package:underdog/underdog_theme.dart';

import 'data/models/user_location.dart';

class UnderdogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    // TODO: Remove this when the theme is decided
    final color = Colors.pink;
    UnderdogTheme.color = color;

    return MultiProvider(
      providers: [
        StreamProvider<UserLocation>(
          builder: (context) => locator<LocationService>().locationStream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Underdog',
        theme: ThemeData(
            fontFamily: 'Lato',
            inputDecorationTheme:
                InputDecorationTheme(hintStyle: UnderdogTheme.hintText),
            primarySwatch: color,
            accentColor: color,
            cursorColor: color,
            buttonTheme: ButtonThemeData(
              buttonColor: color,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.black12)),
            ),
            cardTheme: CardTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                foregroundColor: color,
                backgroundColor: Colors.white,
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                shape: CircleBorder(side: BorderSide(color: Colors.black12)))),
        home: RootPage(),
      ),
    );
  }
}
