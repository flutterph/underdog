import 'package:flutter/material.dart';

class UnderdogTheme {
  static MaterialColor color = Colors.green;
  static TextStyle pageTitle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 36,
      color: color,
      fontFamily: 'Jua');

  static TextStyle raisedButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle raisedButtonTextDark =
      TextStyle(fontWeight: FontWeight.bold, color: color);

  static TextStyle flatButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: color);
  static TextStyle darkFlatButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle outlineButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: color);
  static TextStyle outlineButtonTextDark =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle hintText = TextStyle(color: Colors.grey, fontSize: 12);
  static TextStyle hintTextDark =
      TextStyle(color: Colors.white70, fontSize: 12);

  static TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: Colors.black54,
  );
  static TextStyle darkLabelStyle = labelStyle.copyWith(color: Colors.white70);
}
