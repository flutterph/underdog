import 'package:flutter/material.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/auth_service.dart';

enum PageState { Idle, Busy }

class RegisterModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  PageState _pageState = PageState.Idle;
  PageState get state => _pageState;

  void setState(PageState state) {
    _pageState = state;
    notifyListeners();
  }

  Future<String> registerUser(
      String email, String password, String firstName, String lastName) async {
    setState(PageState.Busy);

    final String result = await _authService.createUserWithEmailAndPassword(
        email, password, firstName, lastName);

    setState(PageState.Idle);
    return result;
  }
}
