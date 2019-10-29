import 'package:flutter/material.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/auth_service.dart';

enum PageState { Idle, Busy }

class LoginModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  PageState _pageState = PageState.Idle;

  PageState get state => _pageState;

  void setState(PageState state) {
    _pageState = state;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    setState(PageState.Busy);
    final String result = await _authService.login(email, password);

    setState(PageState.Idle);
    return result;
  }
}
