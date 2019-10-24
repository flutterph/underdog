import 'package:get_it/get_it.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:underdog/services/location_service.dart';
import 'package:underdog/services/reports_database_service.dart';
import 'package:underdog/services/storage_service.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/viewmodels/login_model.dart';
import 'package:underdog/viewmodels/reports_model.dart';
import 'package:underdog/viewmodels/select_location_model.dart';
import 'package:underdog/viewmodels/submit_report_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ReportsDatabaseService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => LocationService());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => SubmitReportModel());
  locator.registerFactory(() => SelectLocationModel());
  locator.registerFactory(() => ReportsModel());
}
