import 'dart:async';

import 'package:underdog/data/models/stats.dart';

class StatsStream {
  final StreamController<Stats> _controller =
      StreamController<Stats>.broadcast();

  void updateStats(Stats stats) {
    _controller.sink.add(stats);
  }

  Stream<Stats> get value => _controller.stream;
}
