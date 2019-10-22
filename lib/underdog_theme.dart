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
  static TextStyle outlineButtonText =
      TextStyle(fontWeight: FontWeight.bold, color: color);
  static TextStyle hintText = TextStyle(color: Colors.grey, fontSize: 12);
}
