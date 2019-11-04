import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:underdog/pages/login_page.dart';
import 'package:underdog/viewmodels/home_drawer_model.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/slide_left_page_route.dart';

import '../service_locator.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeDrawerModel>(
      builder: (BuildContext context) => locator<HomeDrawerModel>(),
      child: Consumer<HomeDrawerModel>(
          builder: (BuildContext context, HomeDrawerModel model, Widget child) {
        final bool isBusy = model.state == ViewState.Busy;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isBusy
                ? Container(
                    height: 96,
                    width: 96,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Material(
                            shape: CircleBorder(
                                side: BorderSide(color: Colors.white12)),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: model.user.displayPhotoUrl ??
                                    'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/03-the-joker-w1200-h630-1562679871.jpg?crop=0.526xw:1.00xh;0.238xw,0&resize=480:*',
                                height: 96,
                                width: 96,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${model.user.firstName} ${model.user.lastName}'),
                      const SizedBox(height: 8),
                      AnimatedFlatButton(
                        label: 'Invite your friends',
                        onPressed: () {
                          Share.share(
                              'Hello friends! Become a rescuer and help dogs find their forever home');
                        },
                        // icon: FontAwesomeIcons.connectdevelop,
                      ),
                      const SizedBox(height: 8),
                      AnimatedFlatButton(
                        label: 'Report a user',
                        onPressed: () {},
                        // icon: FontAwesomeIcons.connectdevelop,
                      ),
                      const SizedBox(height: 8),
                      AnimatedFlatButton(
                        label: 'About',
                        onPressed: () {},
                        // icon: FontAwesomeIcons.connectdevelop,
                      ),
                      const SizedBox(height: 8),
                      AnimatedRaisedButton(
                        delay: 125,
                        label: 'Log Out',
                        icon: FontAwesomeIcons.doorOpen,
                        onPressed: () {
                          Provider.of<HomeModel>(context).logout().then(
                            (bool value) {
                              if (value) {
                                Navigator.pushReplacement(
                                  context,
                                  SlideLeftPageRoute<void>(
                                    page: const LoginPage(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
          ),
        );
      }),
    );
  }
}
