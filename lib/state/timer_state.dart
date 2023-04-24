import 'dart:async';
import 'package:flutter/material.dart';

class TimerState extends ChangeNotifier {
  int _secondsLeft = 60;
  Timer? _timer;
  bool _isTimerRunning = false;

  int get secondsLeft => _secondsLeft;

  void startTimer() {
    if (!_isTimerRunning) {
      _secondsLeft = 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          cancelTimer();
        }
        notifyListeners();
      });
      _isTimerRunning = true;
    }
  }

  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
    _isTimerRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }
}