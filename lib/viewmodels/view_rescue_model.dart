import 'package:flutter/cupertino.dart';
import 'package:underdog/data/models/rescue.dart';
import 'package:underdog/data/models/user.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/services/rescues_database_service.dart';
import 'package:underdog/services/users_database_service.dart';

enum PageState { Idle, Busy }

class ViewRescueModel extends ChangeNotifier {
  final RescuesDatabaseService _rescuesDatabaseService =
      locator<RescuesDatabaseService>();
  final UsersDatabaseService _usersDatabaseService =
      locator<UsersDatabaseService>();

  PageState _state = PageState.Busy;
  Rescue _rescue;
  User _rescuer;

  void setState(PageState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadRescue(String uid) async {
    setState(PageState.Busy);
    _rescue = await _rescuesDatabaseService.getRescueByReportId(uid);
    _rescuer =
        await _usersDatabaseService.getUserByRescuerId(_rescue.rescuerId);

    setState(PageState.Idle);
  }

  // Accessors
  PageState get state => _state;
  Rescue get rescue => _rescue;
  User get rescuer => _rescuer;
}
