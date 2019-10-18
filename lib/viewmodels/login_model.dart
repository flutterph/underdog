import 'package:flutter/material.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Represents the state of the view
enum ViewState { Idle, Busy }

class LoginModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  ViewState _state = ViewState.Idle;
  final AuthService _authService = locator<AuthService>();

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    return await _authService.login(email, password);
  }
}
