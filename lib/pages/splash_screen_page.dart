import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';
import 'package:underdog/pages/root_page.dart';

import '../hero_tag.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Fluttie instance;
  FluttieAnimationController wordmarkAnim;

  @override
  void initState() {
    super.initState();
    instance = Fluttie();
    instance
        .loadAnimationFromAsset('assets/wordmark_anim.json')
        .then((int value) async {
      wordmarkAnim = await instance.prepareAnimation(value);
      setState(() {
        wordmarkAnim.start();
      });

      Timer(Duration(milliseconds: 1500), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const RootPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: (wordmarkAnim == null)
              ? Container()
              : Hero(
                  tag: HeroTag.MAIN_TITLE,
                  child: FluttieAnimation(
                    wordmarkAnim,
                    size: const Size(222.5, 62.5),
                  ),
                ),
        ),
      ),
    );
  }
}
