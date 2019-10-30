import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/submit_rescue_page.dart';
import 'package:underdog/pages/view_image_page.dart';
import 'package:underdog/pages/view_rescue_page.dart';
import 'package:underdog/widgets/animated_outline_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/scale_page_route.dart';

import '../underdog_theme.dart';

class ViewReportPage extends StatelessWidget {
  const ViewReportPage({
    Key key,
    this.report,
  }) : super(key: key);

  final Report report;

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
                constraints: const BoxConstraints(maxWidth: 280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                        tag: HeroTag.REPORT_CODE_NAME_ + report.uid,
                        child: Text(report.codeName,
                            style: UnderdogTheme.pageTitle)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            ScalePageRoute<void>(
                                page: ViewImagePage(
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
                                  placeholder: (BuildContext context,
                                          String url) =>
                                      const Center(
                                          child: CircularProgressIndicator()),
                                  errorWidget: (BuildContext context,
                                          String url, Object error) =>
                                      Icon(FontAwesomeIcons.frown),
                                ),
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'BREED',
                      style: UnderdogTheme.labelStyle,
                    ),
                    Text(report.breed),
                    const SizedBox(height: 16),
                    Text(
                      'LAST SEEN',
                      style: UnderdogTheme.labelStyle,
                    ),
                    Hero(
                        tag: HeroTag.REPORT_LANDMARK_ + report.uid,
                        child: Text(
                          report.address,
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 16),
                    Text(
                      'ADDITIONAL INFO',
                      style: UnderdogTheme.labelStyle,
                    ),
                    if (report.additionalInfo.isEmpty)
                      const Text(
                        'None',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      )
                    else
                      Text(report.additionalInfo),
                    const SizedBox(height: 24),
                    if (!report.isRescued)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AnimatedRaisedButton(
                            label: 'Get Directions',
                            onPressed: () {
                              Navigator.pop(context, report);
                            },
                            delay: 125,
                          ),
                          const SizedBox(height: 8),
                          AnimatedOutlineButton(
                            label: 'I rescued this pup!',
                            onPressed: () async {
                              final bool didSubmitRescue = await Navigator.push(
                                  context,
                                  ScalePageRoute<bool>(
                                      page: SubmitRescuePage(report: report)));

                              if (didSubmitRescue) {
                                Navigator.pop(context);
                              }
                            },
                            delay: 250,
                          ),
                        ],
                      )
                    else
                      AnimatedRaisedButton(
                        label: 'View Rescue',
                        onPressed: () {
                          Navigator.push(
                              context,
                              ScalePageRoute<void>(
                                  page: ViewRescuePage(
                                report: report,
                              )));
                        },
                        delay: 125,
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
