import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:underdog/underdog_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UnderdogTheme.mustard,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/illustrations/pet_toys_colour_800px.png',
              width: 300,
            ),
            const SizedBox(height: 32),
            SvgPicture.asset(
              'assets/wordmark.svg',
              width: 156,
              color: Colors.white,
            ),
            const Text(
              'v0.1.1',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'by Oli Atienza',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'My official entry to the first ever Flutter PH Hackathon',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
