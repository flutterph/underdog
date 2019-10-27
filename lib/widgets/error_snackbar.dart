import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  final Widget content;
  const ErrorSnackBar({this.content})
      : super(content: content, backgroundColor: Colors.red);
}
