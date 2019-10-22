import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/viewmodels/reports_model.dart';
import 'package:underdog/widgets/item_report.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBar(elevation: 0, backgroundColor: Colors.transparent),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 96,
                ),
                Text(
                  'Reports',
                  style: UnderdogTheme.pageTitle,
                ),
                SizedBox(
                  height: 32,
                ),
                Expanded(
                  child: FirebaseAnimatedList(
                    query: locator<ReportsModel>().getReports(),
                    key: _listKey,
                    shrinkWrap: true,
                    defaultChild: Center(child: CircularProgressIndicator()),
                    itemBuilder: _buildItem,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, DataSnapshot snapshot,
      Animation animation, int index) {
    final report = Report.fromSnapshot(snapshot);

    return ReportItem(
      report: report,
    );
  }
}
