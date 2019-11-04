import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/stats.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/viewmodels/home_model.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle countStyle =
        TextStyle(fontSize: 28, color: Theme.of(context).accentColor);
    final TextStyle labelStyle =
        TextStyle(fontWeight: FontWeight.bold, color: UnderdogTheme.darkTeal);

    return StreamBuilder<Stats>(
      stream: Provider.of<HomeModel>(context).watchStats(),
      builder: (BuildContext context, AsyncSnapshot<Stats> snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${_createGreetingString()}',
                  style: TextStyle(fontSize: 24, color: UnderdogTheme.teal),
                ),
                Text(
                  'as of the moment, there are',
                  style: TextStyle(fontSize: 14, color: UnderdogTheme.darkTeal),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          '${snapshot.data.reportCount}',
                          style: countStyle,
                        ),
                        Text(
                          'Reports',
                          style: labelStyle,
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '${snapshot.data.rescueCount}',
                          style: countStyle,
                        ),
                        Text('Rescues', style: labelStyle)
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }
      },
    );

    // return Consumer<HomeModel>(
    //   builder: (BuildContext context, HomeModel model, Widget child) {
    //     if (model.stats == null) {
    //       return const Padding(
    //         padding: EdgeInsets.all(16.0),
    //         child: Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     } else {
    //       return Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Text(
    //               '${_createGreetingString()}',
    //               style: TextStyle(fontSize: 24, color: UnderdogTheme.teal),
    //             ),
    //             Text(
    //               'as of the moment, there are',
    //               style: TextStyle(fontSize: 14, color: UnderdogTheme.darkTeal),
    //             ),
    //             const SizedBox(height: 8),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: <Widget>[
    //                 Column(
    //                   children: <Widget>[
    //                     Text(
    //                       '${model.stats.reportCount}',
    //                       style: countStyle,
    //                     ),
    //                     Text(
    //                       'Reports',
    //                       style: labelStyle,
    //                     )
    //                   ],
    //                 ),
    //                 Column(
    //                   children: <Widget>[
    //                     Text(
    //                       '${model.stats.rescueCount}',
    //                       style: countStyle,
    //                     ),
    //                     Text('Rescues', style: labelStyle)
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(height: 8),
    //           ],
    //         ),
    //       );
    //     }
    //   },
    // );
  }

  String _createGreetingString() {
    final DateTime now = DateTime.now();

    if (now.hour > 18) {
      return 'Good Evening';
    }

    if (now.hour > 11) {
      return 'Good Afternoon';
    }

    return 'Good Morning';
  }
}
