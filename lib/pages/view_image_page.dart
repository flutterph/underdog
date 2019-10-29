import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:underdog/hero_tag.dart';

class ViewImagePage extends StatelessWidget {
  const ViewImagePage({Key key, this.url, this.uid}) : super(key: key);

  final String url;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Hero(
            tag: HeroTag.REPORT_IMAGE_ + uid,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (BuildContext context, String url) => Center(
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (BuildContext context, String url, Object error) =>
                    Icon(FontAwesomeIcons.frown),
              ),
            ),
          ),
          AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
