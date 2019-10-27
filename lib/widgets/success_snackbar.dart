import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  final Widget content;
  const SuccessSnackBar({this.content})
      : super(content: content, backgroundColor: Colors.green);
}
