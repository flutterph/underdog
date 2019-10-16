import 'package:flutter/material.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class SuperellipseIconButton extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final Color color;
  const SuperellipseIconButton(
      {Key key,
      @required this.iconData,
      @required this.onTap,
      @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(iconData),
        ),
      ),
    );
  }
}
