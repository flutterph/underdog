import 'dart:async';

import 'package:flutter/material.dart';

import '../underdog_theme.dart';

class AnimatedOutlineButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final bool isBusy;
  final int delay;
  AnimatedOutlineButton(
      {Key key,
      @required this.onPressed,
      @required this.label,
      this.isBusy = false,
      this.delay = 0})
      : super(key: key);

  @override
  _AnimatedOutlineButtonState createState() => _AnimatedOutlineButtonState();
}

class _AnimatedOutlineButtonState extends State<AnimatedOutlineButton>
    with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController.addListener(() {
      setState(() {});
    });
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    if (widget.delay > 0) {
      Timer(Duration(milliseconds: widget.delay), () {
        _animationController.forward();
      });
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _animation.value,
      child: OutlineButton(
          color: Theme.of(context).accentColor,
          borderSide: BorderSide(color: Theme.of(context).accentColor),
          child: AnimatedSize(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            vsync: this,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.label,
                  style: UnderdogTheme.outlineButtonText,
                ),
                (widget.isBusy)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          onPressed: widget.onPressed),
    );
  }
}
