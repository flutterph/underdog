import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';

import '../underdog_theme.dart';

class ViewReportPage extends StatelessWidget {
  final Report report;
  const ViewReportPage({
    Key key,
    this.report,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          Material(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                      tag: HeroTag.REPORT_CODE_NAME_ + report.uid,
                      child: Text(report.codeName,
                          style: UnderdogTheme.pageTitle)),
                  Hero(
                      tag: HeroTag.REPORT_BREED_ + report.uid,
                      child: Text(report.breed)),
                  SizedBox(
                    height: 24,
                  ),
                  Hero(
                      tag: HeroTag.REPORT_IMAGE_ + report.uid,
                      child: Container(
                        height: 256,
                        width: 256,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
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
                          //   height: 256,
                          //   width: 256,
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
                  Hero(
                      tag: HeroTag.REPORT_LANDMARK_ + report.uid,
                      child: Text(report.landmark)),
                  Text(report.additionalInfo),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Text(
                          'Get Directions',
                          style: UnderdogTheme.raisedButtonText,
                        )),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  OutlineButton(
                    color: Theme.of(context).accentColor,
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Text(
                          'I rescued this pup!',
                          style: UnderdogTheme.outlineButtonText,
                        )),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
