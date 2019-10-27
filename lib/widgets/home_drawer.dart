import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:underdog/pages/login_page.dart';
import 'package:underdog/viewmodels/home_drawer_model.dart';
import 'package:underdog/viewmodels/home_model.dart';

import '../service_locator.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeDrawerModel>(
      builder: (context) => locator<HomeDrawerModel>(),
      child: Consumer<HomeDrawerModel>(
        builder: (context, model, child) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Material(
                      shape:
                          CircleBorder(side: BorderSide(color: Colors.white12)),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/03-the-joker-w1200-h630-1562679871.jpg?crop=0.526xw:1.00xh;0.238xw,0&resize=480:*',
                          height: 96,
                          width: 96,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('${model.user.displayName}'),
                IconButton(
                  icon: Icon(FontAwesomeIcons.doorOpen),
                  onPressed: () {
                    Provider.of<HomeModel>(context).logout().then((value) {
                      if (value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
