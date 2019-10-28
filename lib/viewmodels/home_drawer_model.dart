import 'package:flutter/foundation.dart';
import 'package:underdog/data/models/user.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/pref_service.dart';

enum ViewState { Idle, Busy }

class HomeDrawerModel extends ChangeNotifier {
  final PrefService _prefService = locator<PrefService>();

  ViewState _state = ViewState.Idle;
  User _user;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  HomeDrawerModel() {
    getUser();
  }

  Future<void> getUser() async {
    setState(ViewState.Busy);
    _user = await _prefService.getUserInPrefs();

    setState(ViewState.Idle);
  }

  ViewState get state => _state;
  User get user => _user;
}
