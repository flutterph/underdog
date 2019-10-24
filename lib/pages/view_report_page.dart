import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/view_image_page.dart';

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
              child: Container(
                constraints: BoxConstraints(maxWidth: 280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                        tag: HeroTag.REPORT_CODE_NAME_ + report.uid,
                        child: Text(report.codeName,
                            style: UnderdogTheme.pageTitle)),
                    SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewImagePage(
                                      url: report.imageUrl,
                                      uid: report.uid,
                                    )));
                      },
                      child: Hero(
                          tag: HeroTag.REPORT_IMAGE_ + report.uid,
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.black12)),
                            child: SizedBox(
                              height: 280,
                              width: 280,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: report.imageUrl,
                                  fit: BoxFit.cover,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(FontAwesomeIcons.frown),
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'BREED',
                      style: UnderdogTheme.labelStyle,
                    ),
                    Hero(
                        tag: HeroTag.REPORT_BREED_ + report.uid,
                        child: Text(report.breed)),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'LAST SEEN',
                      style: UnderdogTheme.labelStyle,
                    ),
                    Hero(
                        tag: HeroTag.REPORT_LANDMARK_ + report.uid,
                        child: Text(report.landmark)),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'ADDITIONAL INFO',
                      style: UnderdogTheme.labelStyle,
                    ),
                    Text(report.additionalInfo),
                    SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      child: Text(
                        'Get Directions',
                        style: UnderdogTheme.raisedButtonText,
                      ),
                      onPressed: () {
                        Navigator.pop(context, report);
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    OutlineButton(
                      color: Theme.of(context).accentColor,
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                      child: Text(
                        'I rescued this pup!',
                        style: UnderdogTheme.outlineButtonText,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
