import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/view_report_page.dart';

class ReportItem extends StatelessWidget {
  final Report report;
  const ReportItem({Key key, this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewReportPage(
                        report: report,
                      )));
        },
        child: Container(
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
                  Hero(
                      tag: HeroTag.REPORT_IMAGE_ + report.uid,
                      child: SizedBox(
                        height: 96,
                        width: 96,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: report.imageUrl,
                            fit: BoxFit.cover,
                            useOldImageOnUrlChange: true,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(FontAwesomeIcons.frown),
                          ),
                          // child: Image.network(
                          //   report.imageUrl,
                          //   fit: BoxFit.cover,
                          //   loadingBuilder: (context, child, loadingProgress) {
                          //     if (loadingProgress == null) return child;

                          //     return Center(
                          //       child: CircularProgressIndicator(
                          //         value: loadingProgress.expectedTotalBytes !=
                          //                 null
                          //             ? loadingProgress.cumulativeBytesLoaded /
                          //                 loadingProgress.expectedTotalBytes
                          //             : null,
                          //       ),
                          //     );
                          //   },
                          // ),
                        ),
                      )),
                  SizedBox(
                    width: 16,
                  ),
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
                        Hero(
                            tag: HeroTag.REPORT_BREED_ + report.uid,
                            child: Text(report.breed)),
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
                                Hero(
                                  tag: HeroTag.REPORT_LANDMARK_ + report.uid,
                                  child: Text(
                                    report.landmark,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Text(
                                  '${report.latitude}, ${report.longitude}',
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
        ),
      ),
    );
  }
}
