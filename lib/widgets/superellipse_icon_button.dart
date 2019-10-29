import 'package:flutter/material.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class SuperellipseIconButton extends StatelessWidget {
  const SuperellipseIconButton({
    Key key,
    @required this.iconData,
    @required this.onTap,
    @required this.bgColor,
    @required this.iconColor,
  }) : super(key: key);

  final IconData iconData;
  final Function onTap;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: bgColor,
      shape: SuperellipseShape(borderRadius: BorderRadius.circular(32)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            iconData,
            color: iconColor,
            size: 32,
          ),
        ),
      ),
    );
  }
}
