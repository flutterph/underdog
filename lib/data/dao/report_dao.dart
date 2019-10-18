import 'package:floor/floor.dart';
import 'package:underdog/data/models/report.dart';

@dao
abstract class ReportDao {
  @Query("SELECT * FROM Report")
  Future<List<Report>> getAll();

  @Query("SELECT * FROM Report")
  Stream<List<Report>> watchAll();

  @Insert()
  Future<void> insert(Report report);
}
