import 'package:flutter/material.dart';
import 'package:underdog/service_locator.dart';

import 'underdog_app.dart';

void main() {
  setupLocator();
  runApp(UnderdogApp());
}
