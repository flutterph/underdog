import 'package:flutter/material.dart';

class NeutralSnackBar extends SnackBar {
  final Widget content;
  const NeutralSnackBar({this.content})
      : super(content: content, backgroundColor: Colors.amber);
}
