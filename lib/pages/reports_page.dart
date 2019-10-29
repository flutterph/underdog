import 'package:flutter/material.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/widgets/rescued_reports_list.dart';
import 'package:underdog/widgets/unrescued_reports_list.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  TextStyle _tabStyle;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _tabStyle = TextStyle(
        color: Theme.of(context).accentColor, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBar(elevation: 0, backgroundColor: Colors.transparent),
          Container(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 96),
                Text(
                  'Reports',
                  style: UnderdogTheme.pageTitle,
                ),
                const SizedBox(height: 32),
                TabBar(
                  controller: _tabController,
                  labelPadding: const EdgeInsets.all(16),
                  indicatorColor: Theme.of(context).accentColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Text(
                      'Unrescued',
                      style: _tabStyle,
                    ),
                    Text(
                      'Rescued',
                      style: _tabStyle,
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const <Widget>[
                      UnrescuedReportsList(),
                      RescuedReportsList(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
