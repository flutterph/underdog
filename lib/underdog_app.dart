import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:underdog/pages/home_page.dart';
import 'package:underdog/services/location_service.dart';

import 'data/models/user_location.dart';

class UnderdogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserLocation>(
          builder: (context) => LocationService().locationStream,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: HomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
