import 'dart:async';

import 'package:flutter/material.dart';

import '../underdog_theme.dart';

class AnimatedRaisedButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final bool isBusy;
  final int delay;
  final IconData icon;
  final Color color;
  final TextStyle style;
  AnimatedRaisedButton(
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
  _AnimatedRaisedButtonState createState() => _AnimatedRaisedButtonState();
}

class _AnimatedRaisedButtonState extends State<AnimatedRaisedButton>
    with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  Color _color;
  TextStyle _style;
  Color _pbColor;

  @override
  void initState() {
    super.initState();

    // Theme and colors
    _color = (widget.color) ?? Theme.of(context).accentColor;
    _style = (widget.style) ?? UnderdogTheme.raisedButtonText;
    _pbColor = (_color == Theme.of(context).accentColor)
        ? Colors.white
        : Theme.of(context).accentColor;

    // Animation
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController.addListener(() {
      setState(() {});
    });
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    if (widget.delay > 0)
      Timer(Duration(milliseconds: widget.delay), () {
        _animationController.forward();
      });
    else
      _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: RaisedButton(
          disabledColor: _color,
          child: AnimatedSize(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            vsync: this,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (widget.icon != null)
                    ? Row(
                        children: <Widget>[
                          Icon(widget.icon, size: 20, color: _pbColor),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  widget.label,
                  style: _style,
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
                              backgroundColor: _pbColor,
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

  // @override
  // Widget build(BuildContext context) {
  //   final color = (widget.color) ?? Theme.of(context).accentColor;
  //   final style = (widget.style) ?? UnderdogTheme.raisedButtonText;
  //   final pbColor = (color == Theme.of(context).accentColor)
  //       ? Colors.white
  //       : Theme.of(context).accentColor;

  //   return Transform.scale(
  //     scale: _animation.value,
  //     child: RaisedButton(
  //         disabledColor: color,
  //         child: AnimatedSize(
  //           duration: Duration(milliseconds: 500),
  //           curve: Curves.fastOutSlowIn,
  //           vsync: this,
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               (widget.icon != null)
  //                   ? Row(
  //                       children: <Widget>[
  //                         Icon(widget.icon, size: 20, color: Colors.white),
  //                         SizedBox(
  //                           width: 4,
  //                         ),
  //                       ],
  //                     )
  //                   : Container(),
  //               Text(
  //                 widget.label,
  //                 style: style,
  //               ),
  //               (widget.isBusy)
  //                   ? Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: <Widget>[
  //                         SizedBox(
  //                           width: 8,
  //                         ),
  //                         SizedBox(
  //                           height: 10,
  //                           width: 10,
  //                           child: CircularProgressIndicator(
  //                             backgroundColor: pbColor,
  //                             strokeWidth: 2,
  //                           ),
  //                         )
  //                       ],
  //                     )
  //                   : Container()
  //             ],
  //           ),
  //         ),
  //         onPressed: widget.onPressed),
  //   );
  // }
}
