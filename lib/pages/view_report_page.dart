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
    const TextStyle _body = TextStyle(fontSize: 18, color: UnderdogTheme.black);
    const double radius = 56;

    return Scaffold(
      backgroundColor: UnderdogTheme.teal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Material(
            color: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.89,
              width: double.infinity,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius)),
                side: BorderSide(color: Colors.white12)),
          ),
          Material(
            color: UnderdogTheme.mustard,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.33,
              width: double.infinity,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius)),
                side: BorderSide(color: Colors.white12)),
          ),
          Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Hero(
                          tag: HeroTag.REPORT_CODE_NAME_ + report.uid,
                          child: Text(report.codeName,
                              style: UnderdogTheme.pageTitle)),
                    ),
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
                                side: BorderSide(color: Colors.black12)),
                            child: SizedBox(
                              height: 300,
                              width: 300,
                              child: CachedNetworkImage(
                                imageUrl: report.imageUrl,
                                fit: BoxFit.cover,
                                useOldImageOnUrlChange: true,
                                placeholder:
                                    (BuildContext context, String url) =>
                                        const Center(
                                            child: CircularProgressIndicator()),
                                errorWidget: (BuildContext context, String url,
                                        Object error) =>
                                    Icon(FontAwesomeIcons.frown),
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'BREED',
                              style: UnderdogTheme.labelStyle,
                            ),
                            Text(
                              report.breed,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _body,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'LAST SEEN',
                              style: UnderdogTheme.labelStyle,
                            ),
                            Hero(
                                tag: HeroTag.REPORT_LANDMARK_ + report.uid,
                                child: Text(
                                  report.address,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: _body,
                                )),
                            const SizedBox(height: 16),
                            Text(
                              'ADDITIONAL INFO',
                              style: UnderdogTheme.labelStyle,
                            ),
                            if (report.additionalInfo.isEmpty)
                              Text(
                                'None',
                                style:
                                    _body.copyWith(fontStyle: FontStyle.italic),
                              )
                            else
                              Text(
                                report.additionalInfo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: _body,
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22.0),
              child: (!report.isRescued)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedRaisedButton(
                          label: 'Get Directions',
                          onPressed: () {
                            Navigator.pop(context, report);
                          },
                          delay: 125,
                        ),
                        const SizedBox(width: 8),
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
                  : FittedBox(
                      child: AnimatedRaisedButton(
                        label: 'View Rescue',
                        color: Colors.white,
                        style: UnderdogTheme.darkRaisedButtonText,
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
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
