import 'package:flutter/material.dart';

class ThemeUtils {
  static MaterialColor createMaterialColorFromShade500(Color shade500) {
    final Map<int, Color> swatch = <int, Color>{
      50: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.1),
      100: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.2),
      200: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.3),
      300: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.4),
      400: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.5),
      500: shade500,
      600: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.7),
      700: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.8),
      800: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 0.9),
      900: Color.fromRGBO(shade500.red, shade500.green, shade500.green, 1.0),
    };

    return MaterialColor(shade500.value, swatch);
  }
}
