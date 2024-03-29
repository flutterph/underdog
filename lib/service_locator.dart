import 'package:get_it/get_it.dart';
import 'package:underdog/services/auth_service.dart';
import 'package:underdog/services/location_service.dart';
import 'package:underdog/services/pref_service.dart';
import 'package:underdog/services/reports_database_service.dart';
import 'package:underdog/services/rescues_database_service.dart';
import 'package:underdog/services/storage_service.dart';
import 'package:underdog/services/users_database_service.dart';
import 'package:underdog/viewmodels/home_drawer_model.dart';
import 'package:underdog/viewmodels/home_model.dart';
import 'package:underdog/viewmodels/login_model.dart';
import 'package:underdog/viewmodels/register_model.dart';
import 'package:underdog/viewmodels/reports_model.dart';
import 'package:underdog/viewmodels/rescued_reports_list_model.dart';
import 'package:underdog/viewmodels/select_location_model.dart';
import 'package:underdog/viewmodels/submit_report_model.dart';
import 'package:underdog/viewmodels/submit_rescue_model.dart';
import 'package:underdog/viewmodels/unrescued_reports_list_model.dart';
import 'package:underdog/viewmodels/view_rescue_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UsersDatabaseService());
  locator.registerLazySingleton(() => ReportsDatabaseService());
  locator.registerLazySingleton(() => RescuesDatabaseService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => PrefService());

  // Widgets
  locator.registerFactory(() => HomeDrawerModel());
  locator.registerFactory(() => RescuedReportsListModel());
  locator.registerFactory(() => UnrescuedReportsListModel());

  // Pages
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => RegisterModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => SubmitReportModel());
  locator.registerFactory(() => SubmitRescueModel());
  locator.registerFactory(() => ViewRescueModel());
  locator.registerFactory(() => SelectLocationModel());
  locator.registerFactory(() => ReportsModel());
}
