import 'package:floor/floor.dart';
import 'package:underdog/data/models/user.dart';

@dao
abstract class UserDao {
  @Query("SELECT * FROM User")
  Future<List<User>> getAll();

  @Insert()
  Future<void> insert(User user);
}
