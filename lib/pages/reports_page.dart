import 'package:flutter/material.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/view_utils.dart';
import 'package:underdog/widgets/my_back_button.dart';
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

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 56;

    return Scaffold(
      backgroundColor: UnderdogTheme.dirtyWhite,
      body: Stack(
        children: <Widget>[
          Material(
            color: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.94,
              width: double.infinity,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius)),
                side: BorderSide(color: Colors.white12)),
          ),
          Material(
            color: UnderdogTheme.teal,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.29,
              width: double.infinity,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius)),
                side: BorderSide(color: Colors.white12)),
          ),
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: const MyBackButton(),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ViewUtils.createTopSpacing(),
                const Text(
                  'Reports',
                  style: UnderdogTheme.pageTitle,
                ),
                const SizedBox(height: 8),
                TabBar(
                  controller: _tabController,
                  labelPadding: const EdgeInsets.all(16),
                  indicatorColor: Colors.white,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  tabs: const <Widget>[
                    Text(
                      'Unrescued',
                    ),
                    Text('Rescued'),
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
