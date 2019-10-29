import 'dart:async';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../underdog_theme.dart';

class AnimatedRaisedButton extends StatefulWidget {
  const AnimatedRaisedButton(
      {Key key,
      @required this.onPressed,
      @required this.label,
      this.isBusy = false,
      this.delay = 0,
      this.icon,
      this.color,
      this.style,
      this.progressColor})
      : super(key: key);

  final Function onPressed;
  final String label;
  final bool isBusy;
  final int delay;
  final IconData icon;
  final Color color;
  final TextStyle style;
  final Color progressColor;

  @override
  _AnimatedRaisedButtonState createState() => _AnimatedRaisedButtonState();
}

class _AnimatedRaisedButtonState extends State<AnimatedRaisedButton>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  Color _color;
  TextStyle _style;
  Color _progressColor;

  @override
  void initState() {
    super.initState();

    // Animation
    _animationController = AnimationController(
        duration: const Duration(
            milliseconds: Constants.DEFAULT_ANIMATION_DURATION_MS),
        vsync: this);
    _animationController.addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    if (widget.delay > 0)
      Timer(Duration(milliseconds: widget.delay), () {
        _animationController.forward();
      });
    else
      _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Theme and colors
    _color = (widget.color) ?? Theme.of(context).accentColor;
    _style = (widget.style) ?? UnderdogTheme.raisedButtonText;
    _progressColor = (widget.progressColor) ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: RaisedButton(
          disabledColor: _color,
          color: _color,
          child: AnimatedSize(
            duration: const Duration(
                milliseconds: Constants.DEFAULT_ANIMATION_DURATION_MS),
            curve: Curves.fastOutSlowIn,
            vsync: this,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.icon != null)
                  Row(
                    children: <Widget>[
                      Icon(widget.icon, size: 20, color: _progressColor),
                      const SizedBox(width: 12),
                    ],
                  )
                else
                  Container(),
                Text(
                  widget.label,
                  style: _style,
                ),
                if (widget.isBusy)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          backgroundColor: _progressColor,
                          strokeWidth: 2,
                        ),
                      )
                    ],
                  )
                else
                  Container()
              ],
            ),
          ),
          onPressed: widget.onPressed),
    );
  }
}
