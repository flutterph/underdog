import 'package:flutter/material.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';

import '../underdog_theme.dart';

class ViewReportPage extends StatelessWidget {
  final Report report;
  final int id;
  const ViewReportPage({
    Key key,
    this.report,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: HeroTag.REPORT_CARD_,
        child: Stack(
          children: <Widget>[
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            Column(
              children: <Widget>[
                Text(report.codeName, style: UnderdogTheme.pageTitle),
                Image.network(report.imageUrl),
                Text(report.breed),
                Text(report.landmark),
                Text(report.additionalInfo),
                RaisedButton(
                  child: Text('Get Directions'),
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text('I rescued this guy!'),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
