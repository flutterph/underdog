import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../hero_tag.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          FontAwesomeIcons.user,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black12)),
      centerTitle: true,
      title: Hero(
        tag: HeroTag.MAIN_TITLE,
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SvgPicture.asset(
              'assets/wordmark.svg',
              width: 112,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
