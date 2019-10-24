import 'package:flutter/material.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/auth_service.dart';

class LoginModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();

  Future<String> login(String email, String password) async {
    return await _authService.login(email, password);
  }
}
