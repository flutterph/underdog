import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/date_time_utils.dart';
import 'package:underdog/hero_tag.dart';

class ReportItem extends StatelessWidget {
  const ReportItem({Key key, this.report}) : super(key: key);

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: <Widget>[
                Hero(
                    tag: HeroTag.REPORT_IMAGE_ + report.uid,
                    child: SizedBox(
                      height: 152,
                      width: 152,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: report.imageUrl,
                          fit: BoxFit.cover,
                          useOldImageOnUrlChange: true,
                          placeholder: (BuildContext context, String url) =>
                              Center(child: const CircularProgressIndicator()),
                          errorWidget: (BuildContext context, String url,
                                  Object error) =>
                              Icon(FontAwesomeIcons.frown),
                        ),
                      ),
                    )),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: HeroTag.REPORT_CODE_NAME_ + report.uid,
                        child: Text(
                          report.codeName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(report.breed),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: Theme.of(context).accentColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  report.address,
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
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.calendar,
                            color: Theme.of(context).accentColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              DateTimeUtils.dateStringToDisplayString(
                                  report.date),
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
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
      ),
    );
  }
}
