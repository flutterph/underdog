import 'package:flutter/material.dart';
import 'package:underdog/pages/home_page.dart';
import 'package:underdog/pages/login_page.dart';
import 'package:underdog/services/auth_service.dart';

import '../service_locator.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();
    final _authService = locator<AuthService>();
    _authService.checkAuthStatus().then((value) {
      setState(() {
        _authStatus = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return Scaffold(
          body: Center(
            child: Text(
              'Underdog',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        );
        break;
      case AuthStatus.NOT_LOGGED_IN:
        print('Not logged in');
        return LoginPage();
        break;
      case AuthStatus.LOGGED_IN:
        print('Logged in');
        return HomePage();
        break;
    }

    return Scaffold(
      body: Center(
        child: Text(
          'Underdog',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
    );
  }
}
