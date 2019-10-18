import 'package:flutter/material.dart';
import 'package:underdog/services/auth_service.dart';

import '../service_locator.dart';

class HomeModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  Future<bool> logout() async {
    return _authService.logout();
  }
}
