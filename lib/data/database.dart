import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:underdog/data/dao/report_dao.dart';

import 'dao/user_dao.dart';
import 'models/report.dart';
import 'models/user.dart';

part 'database.g.dart';

@Database(version: 1, entities: [User, Report])
abstract class AppDatabase extends FloorDatabase {
  UserDao get personDao;
  ReportDao get reportDao;
}
