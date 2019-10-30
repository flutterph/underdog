import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/view_image_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/view_rescue_model.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_outline_button.dart';
import 'package:underdog/widgets/scale_page_route.dart';

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
    return ChangeNotifierProvider<ViewRescueModel>(
        builder: (BuildContext context) => _viewRescueModel,
        child: Consumer<ViewRescueModel>(
          builder: (BuildContext context, ViewRescueModel model, Widget child) {
            final bool isBusy = model.state == PageState.Busy;

            return Scaffold(
              backgroundColor: Theme.of(context).accentColor,
              body: Center(
                child: isBusy
                    ? const CircularProgressIndicator()
                    : Container(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.report.codeName,
                                style: UnderdogTheme.pageTitle
                                    .copyWith(color: Colors.white)),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    ScalePageRoute<void>(
                                        page: ViewImagePage(
                                      url: model.rescue.imageUrl,
                                      uid: widget.report.uid,
                                    )));
                              },
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
                            const SizedBox(height: 16),
                            Text(
                              'RESCUER',
                              style: UnderdogTheme.darkLabelStyle,
                            ),
                            Text(
                              '${model.rescuer.firstName} ${model.rescuer.lastName}',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'FOUND AT',
                              style: UnderdogTheme.darkLabelStyle,
                            ),
                            Text(
                              model.rescue.address,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            // const SizedBox(height: 16),
                            // Text(
                            //   'ADDITIONAL INFO',
                            //   style: UnderdogTheme.darkLabelStyle,
                            // ),
                            // if (widget.report.additionalInfo.isEmpty)
                            //   const Text(
                            //     'None',
                            //     style:
                            //         TextStyle(fontStyle: FontStyle.italic),
                            //   )
                            // else
                            //   Text(widget.report.additionalInfo),
                            const SizedBox(height: 16),
                            AnimatedOutlineButton(
                              label: 'Back',
                              color: Colors.white,
                              style: UnderdogTheme.darkFlatButtonText,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              delay: 125,
                            ),
                          ],
                        ),
                      ),
              ),
            );
          },
        ));
  }
}
