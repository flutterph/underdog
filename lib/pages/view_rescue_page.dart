import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/pages/view_image_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/view_rescue_model.dart';
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
                      height: MediaQuery.of(context).size.height * 0.89,
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
                            constraints: BoxConstraints(
                                maxWidth: 300,
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.89),
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
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                        side:
                                            BorderSide(color: Colors.black12)),
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
                                        Text(
                                          model.rescue.address,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: bodyStyle,
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
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: FittedBox(
                        child: AnimatedOutlineButton(
                          label: 'Back',
                          color: UnderdogTheme.teal,
                          style: UnderdogTheme.flatButtonText,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          delay: 125,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
