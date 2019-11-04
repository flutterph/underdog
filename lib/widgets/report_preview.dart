import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';

import '../date_time_utils.dart';
import '../underdog_theme.dart';

class ReportPreview extends StatelessWidget {
  const ReportPreview({Key key, this.report}) : super(key: key);

  final Report report;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 104,
                width: 104,
                child: Material(
                  borderOnForeground: true,
                  shape: ContinuousRectangleBorder(
                      side: BorderSide(color: Colors.black12)),
                  child: CachedNetworkImage(
                    imageUrl: report.imageUrl,
                    fit: BoxFit.cover,
                    useOldImageOnUrlChange: true,
                    placeholder: (BuildContext context, String url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (BuildContext context, String url, Object error) =>
                            Icon(FontAwesomeIcons.frown),
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          size: 16,
                          color: UnderdogTheme.mustard,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                report.address,
                                style: const TextStyle(fontSize: 12),
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
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.calendar,
                          color: UnderdogTheme.mustard,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            DateTimeUtils.dateStringToDisplayString(
                                report.date),
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedFlatButton(
                label: 'Cancel',
                onPressed: () {
                  Provider.of<HomeModel>(context).clearSelectedReport();
                },
                delay: 125,
              ),
              const SizedBox(width: 8),
              AnimatedRaisedButton(
                label: 'Navigate',
                icon: FontAwesomeIcons.mapMarkedAlt,
                color: UnderdogTheme.teal,
                onPressed: () {
                  if (report.address != null)
                    MapsLauncher.launchQuery(report.address);
                  else
                    MapsLauncher.launchCoordinates(
                        report.latitude, report.longitude);
                },
                delay: 250,
              ),
            ],
          )
        ],
      ),
    );
  }
}
