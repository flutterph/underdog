import 'package:flutter/material.dart';
import 'package:underdog/theme_utils.dart';

mixin UnderdogTheme {
  // Main color scheme
  static const Color darkTeal = Color(0xff195F6B);
  static const Color teal = Color(0xff16BAC6);
  static const Color dirtyWhite = Color(0xffEFF0F4);
  static const Color mustard = Color(0xffFDC161);
  static const Color black = Color(0xff112025);

  static MaterialColor tealMaterialColor =
      ThemeUtils.createMaterialColorFromShade500(teal);

  static const TextStyle pageTitle = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 36,
      color: Colors.white,
      fontFamily: 'Jua');

  static const TextStyle raisedButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle darkRaisedButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: teal);

  static const TextStyle flatButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: teal);
  static const TextStyle darkFlatButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

  static const TextStyle outlineButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: teal);
  static const TextStyle outlineButtonTextDark =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle hintText = TextStyle(color: Colors.grey, fontSize: 12);
  static TextStyle darkHintText =
      TextStyle(color: Colors.white70, fontSize: 12);

  static TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.black38,
  );
  static TextStyle darkLabelStyle = labelStyle.copyWith(color: Colors.white70);
}
