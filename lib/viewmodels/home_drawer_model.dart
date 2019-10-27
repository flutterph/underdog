import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/auth_service.dart';

enum ViewState { Idle, Busy }

class HomeDrawerModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  ViewState _state = ViewState.Idle;
  FirebaseUser _user;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  HomeDrawerModel() {
    getUser();
  }

  Future<void> getUser() async {
    setState(ViewState.Busy);
    _user = await _authService.getUser();
    print(_user.uid);
    print(_user.displayName);

    setState(ViewState.Idle);
  }

  ViewState get state => _state;
  FirebaseUser get user => _user;
}
