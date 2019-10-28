import 'package:flutter/foundation.dart';

enum PageState { Idle, Busy }

class SubmitRescueModel extends ChangeNotifier {
  PageState _state = PageState.Idle;

  setState(PageState state) {
    _state = state;
    notifyListeners();
  }
}
