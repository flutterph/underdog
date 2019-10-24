import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:underdog/hero_tag.dart';

class ViewImagePage extends StatelessWidget {
  final url;
  final uid;
  const ViewImagePage({Key key, this.url, this.uid}) : super(key: key);

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
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
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
