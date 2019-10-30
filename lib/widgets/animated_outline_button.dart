import 'dart:async';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../underdog_theme.dart';

class AnimatedOutlineButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final bool isBusy;
  final int delay;
  final IconData icon;
  final Color color;
  final TextStyle style;
  AnimatedOutlineButton(
      {Key key,
      @required this.onPressed,
      @required this.label,
      this.isBusy = false,
      this.delay = 0,
      this.icon,
      this.color,
      this.style})
      : super(key: key);

  @override
  _AnimatedOutlineButtonState createState() => _AnimatedOutlineButtonState();
}

class _AnimatedOutlineButtonState extends State<AnimatedOutlineButton>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  Color _color;
  TextStyle _style;
  Color _pbColor;

  @override
  void initState() {
    super.initState();

    // Animation
    _animationController = AnimationController(
        duration:
            Duration(milliseconds: Constants.DEFAULT_ANIMATION_DURATION_MS),
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
    // Theme and color
    _color = (widget.color) ?? UnderdogTheme.mustard;
    _style = (widget.style) ?? UnderdogTheme.outlineButtonText;
    _pbColor = (_color == UnderdogTheme.mustard)
        ? Colors.white
        : UnderdogTheme.mustard;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _animation.value,
      child: OutlineButton(
          color: _color,
          borderSide: BorderSide(color: _color),
          child: AnimatedSize(
            duration:
                Duration(milliseconds: Constants.DEFAULT_ANIMATION_DURATION_MS),
            curve: Curves.fastOutSlowIn,
            vsync: this,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.icon != null)
                  Row(
                    children: <Widget>[
                      Icon(widget.icon, size: 20, color: _color),
                      const SizedBox(width: 4),
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
                          backgroundColor: _pbColor,
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
