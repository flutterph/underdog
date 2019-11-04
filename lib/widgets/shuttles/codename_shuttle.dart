import 'package:flutter/material.dart';
import 'package:underdog/widgets/shuttles/hero_state.dart';

import '../../underdog_theme.dart';

class CodeNameShuttle extends StatefulWidget {
  const CodeNameShuttle(
      {Key key,
      this.content,
      this.heroState,
      this.mainTextStyle = const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: UnderdogTheme.darkTeal,
          fontFamily: 'Lato'),
      this.subTextStyle = UnderdogTheme.pageTitle,
      this.maxLines,
      this.textOverflow,
      this.isOverflow})
      : super(key: key);

  final String content;
  final HeroState heroState;
  final TextStyle mainTextStyle;

  final TextStyle subTextStyle;
  final int maxLines;
  final TextOverflow textOverflow;
  final bool isOverflow;

  @override
  _CodeNameShuttleState createState() => _CodeNameShuttleState();
}

class _CodeNameShuttleState extends State<CodeNameShuttle>
    with SingleTickerProviderStateMixin {
  TextStyle _textStyle;

  @override
  void initState() {
    super.initState();

    switch (widget.heroState) {
      case HeroState.Pushing:
        setState(() {
          if (_textStyle != widget.subTextStyle) {
            _textStyle = widget.subTextStyle;
          }
        });
        break;

      case HeroState.Pushed:
        setState(() {
          if (_textStyle != widget.subTextStyle) {
            _textStyle = widget.subTextStyle;
          }
        });
        break;

      case HeroState.Popping:
        setState(() {
          if (_textStyle != widget.mainTextStyle) {
            _textStyle = widget.mainTextStyle;
          }
        });
        break;

      case HeroState.Popped:
        setState(() {
          if (_textStyle != widget.mainTextStyle) {
            _textStyle = widget.mainTextStyle;
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      style: _textStyle,
      duration: const Duration(milliseconds: 300),
      child: Text(
        widget.content,
        overflow: TextOverflow.visible,
        softWrap: false,
      ),
    );
  }
}
