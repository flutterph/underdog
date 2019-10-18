import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportItem extends StatelessWidget {
  const ReportItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: <Widget>[
              FlutterLogo(
                size: 96,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Codename',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('Breed'),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.mapMarkerAlt),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Landmark',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '12.9525, 122.2658',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
