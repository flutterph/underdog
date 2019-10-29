import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/home_page.dart';
import 'package:underdog/pages/login_page.dart';
import 'package:underdog/services/auth_service.dart';

import '../service_locator.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    final AuthService _authService = locator<AuthService>();
    _authService.checkAuthStatus().then((AuthStatus value) {
      switch (value) {
        case AuthStatus.NOT_DETERMINED:
          break;
        case AuthStatus.NOT_LOGGED_IN:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginPage()));
          break;
        case AuthStatus.LOGGED_IN:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => const HomePage()));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: HeroTag.MAIN_TITLE,
          child: Material(
            child: SvgPicture.asset(
              'assets/wordmark.svg',
              width: 176,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
