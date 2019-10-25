import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/viewmodels/home_model.dart';

import '../underdog_theme.dart';

class ReportPreview extends StatelessWidget {
  final Report report;
  const ReportPreview({Key key, this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 96,
                width: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: report.imageUrl,
                    fit: BoxFit.cover,
                    useOldImageOnUrlChange: true,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(FontAwesomeIcons.frown),
                  ),
                ),
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
                      report.codeName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(report.breed),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          size: 16,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                report.landmark,
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              ),
                              Text(
                                '${report.latitude.toStringAsPrecision(7)}, ${report.longitude.toStringAsPrecision(7)}',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: UnderdogTheme.outlineButtonText,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onPressed: () {
                  Provider.of<HomeModel>(context).clearSelectedReport();
                },
              ),
              SizedBox(
                width: 8,
              ),
              RaisedButton.icon(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    FontAwesomeIcons.mapMarkedAlt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  child: Text(
                    'Navigate',
                    style: UnderdogTheme.raisedButtonText,
                  ),
                ),
                onPressed: () {
                  if (report.landmark != null)
                    MapsLauncher.launchQuery(report.landmark);
                  else
                    MapsLauncher.launchCoordinates(
                        report.latitude, report.longitude);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
