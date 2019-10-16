import 'package:flutter/material.dart';
import 'package:underdog/underdog_theme.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 128,
                ),
                Text(
                  'Reports',
                  style: UnderdogTheme.pageTitle,
                ),
                SizedBox(
                  height: 128,
                ),
                AnimatedList(
                  shrinkWrap: true,
                  itemBuilder: _buildItem,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, Animation animation) {
    return Container(
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Row(
            children: <Widget>[
              Placeholder(
                color: Color(0xffffd800),
              ),
              SizedBox(
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
