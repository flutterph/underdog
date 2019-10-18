import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:underdog/pages/root_page.dart';
import 'package:underdog/services/location_service.dart';
import 'package:underdog/underdog_theme.dart';

import 'data/models/user_location.dart';

class UnderdogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MultiProvider(
      providers: [
        StreamProvider<UserLocation>(
          builder: (context) => LocationService().locationStream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Underdog',
        theme: ThemeData(
          fontFamily: 'Lato',
          inputDecorationTheme:
              InputDecorationTheme(hintStyle: UnderdogTheme.hintText),
          primarySwatch: Colors.brown,
        ),
        home: RootPage(),
      ),
    );
  }
}
