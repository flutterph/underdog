import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/view_image_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/view_utils.dart';
import 'package:underdog/viewmodels/view_rescue_model.dart';
import 'package:underdog/widgets/animated_outline_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/slide_left_page_route.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../date_time_utils.dart';
import '../underdog_theme.dart';

class ViewRescuePage extends StatefulWidget {
  const ViewRescuePage({
    Key key,
    this.report,
  }) : super(key: key);

  final Report report;

  @override
  _ViewRescuePageState createState() => _ViewRescuePageState();
}

class _ViewRescuePageState extends State<ViewRescuePage> {
  ViewRescueModel _viewRescueModel;

  @override
  void initState() {
    super.initState();

    _viewRescueModel = locator<ViewRescueModel>();
    _viewRescueModel.loadRescue(widget.report.uid);
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle bodyStyle = TextStyle(fontSize: 18, color: Colors.white);

    return ChangeNotifierProvider<ViewRescueModel>(
        builder: (BuildContext context) => _viewRescueModel,
        child: Consumer<ViewRescueModel>(
          builder: (BuildContext context, ViewRescueModel model, Widget child) {
            final bool isBusy = model.state == PageState.Busy;
            const double radius = 56;

            return Scaffold(
              backgroundColor: UnderdogTheme.dirtyWhite,
              body: Stack(
                children: <Widget>[
                  Material(
                    color: UnderdogTheme.teal,
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                          Constants.PAGE_BOTTOM_BAR_SIZE,
                      width: double.infinity,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(radius),
                            bottomRight: Radius.circular(radius)),
                        side: BorderSide(color: Colors.white12)),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: isBusy
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 128.0),
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ViewUtils.createTopSpacing(),
                                Text(widget.report.codeName,
                                    style: UnderdogTheme.pageTitle
                                        .copyWith(color: Colors.white)),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SlideLeftPageRoute<void>(
                                            page: ViewImagePage(
                                          url: model.rescue.imageUrl,
                                          uid: widget.report.uid,
                                        )));
                                  },
                                  child: Hero(
                                    tag: HeroTag.REPORT_IMAGE_ +
                                        widget.report.uid,
                                    child: Material(
                                      borderOnForeground: true,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.black12)),
                                      child: SizedBox(
                                        height: 300,
                                        width: 300,
                                        child: CachedNetworkImage(
                                          imageUrl: model.rescue.imageUrl,
                                          fit: BoxFit.cover,
                                          useOldImageOnUrlChange: true,
                                          placeholder: (BuildContext context,
                                                  String url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (BuildContext context,
                                                  String url, Object error) =>
                                              Icon(FontAwesomeIcons.frown),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 280),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'RESCUER',
                                          style: UnderdogTheme.darkLabelStyle,
                                        ),
                                        Text(
                                          '${model.rescuer.firstName} ${model.rescuer.lastName}',
                                          style: bodyStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'FOUND AT',
                                          style: UnderdogTheme.darkLabelStyle,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                FontAwesomeIcons.mapMarkerAlt,
                                                color: UnderdogTheme.darkTeal,
                                                size: 20,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                model.rescue.address,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: bodyStyle.copyWith(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                FontAwesomeIcons.calendar,
                                                color: UnderdogTheme.darkTeal,
                                                size: 20,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                DateTimeUtils
                                                    .dateStringToDisplayString(
                                                        model.rescue.date),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: bodyStyle.copyWith(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom:
                              Constants.PAGE_BOTTOM_BAR_ITEMS_BOTTOM_PADDING),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FittedBox(
                            child: AnimatedOutlineButton(
                              label: 'Back',
                              color: UnderdogTheme.darkTeal,
                              style: UnderdogTheme.flatButtonText
                                  .copyWith(color: UnderdogTheme.darkTeal),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              delay: 125,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          FittedBox(
                            child: AnimatedRaisedButton(
                              label: 'Contact Rescuer',
                              color: UnderdogTheme.teal,
                              style: UnderdogTheme.darkFlatButtonText,
                              onPressed: () {
                                _showContactRescuerDialog();
                              },
                              delay: 125,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _showContactRescuerDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Choose an option'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.phone,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Phone',
                          style: UnderdogTheme.raisedButtonText,
                        ),
                      ],
                    ),
                  ),
                  // onPressed: () {
                  //   Navigator.pop(context);
                  //   launch('tel://09178796938');
                  // }
                  onPressed: null),
              const SizedBox(width: 8),
              RaisedButton(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.envelopeOpen,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'E-mail',
                            style: UnderdogTheme.raisedButtonText,
                          ),
                        ],
                      )),
                  onPressed: () {
                    Navigator.pop(context);
                    launch(
                        'mailto:${_viewRescueModel.rescuer.email}?subject=Report User: ${_viewRescueModel.rescuer.firstName} ${_viewRescueModel.rescuer.lastName}&body=This user is bad');
                  }),
            ],
          ),
        );
      },
    );
  }
}
