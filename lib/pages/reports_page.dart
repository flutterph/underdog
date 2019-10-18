import 'package:flutter/material.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/underdog_theme.dart';
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
                  child: AnimatedList(
                    key: _listKey,
                    shrinkWrap: true,
                    initialItemCount: 5,
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

  Widget _buildItem(BuildContext context, int index, Animation animation) {
    return Hero(
        tag: HeroTag.REPORT_CARD_ + index.toString(), child: ReportItem());
  }
}
