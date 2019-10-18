import 'package:get_it/get_it.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/viewmodels/login_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => HomeModel());
}
