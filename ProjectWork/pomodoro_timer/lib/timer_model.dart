import 'package:flutter/foundation.dart';
import 'dart:async';

class TimerModel with ChangeNotifier {
  int _focusDuration = 1500; // Default 25 minutes in seconds
  int _breakDuration = 300; // Default 5 minutes in seconds
  Timer? _timer;
  bool _isRunning = false;
  int _currentDuration = 1500; // To keep track of the current duration

  int get focusDuration => _focusDuration;
  int get breakDuration => _breakDuration;
  bool get isRunning => _isRunning;
  String get currentDurationFormatted {
    final minutes = (_currentDuration ~/ 60).toString().padLeft(2, '0');
    final seconds = (_currentDuration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _isRunning = true;
    _currentDuration = _focusDuration; // Start with focus duration
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentDuration > 0) {
        _currentDuration--;
        notifyListeners();
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _isRunning = false;
    if (_timer != null) {
      _timer!.cancel();
    }
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _currentDuration = _focusDuration; // Reset to the focus duration
    notifyListeners();
  }

  void setFocusDuration(int duration) {
    _focusDuration = duration * 60; // Convert minutes to seconds
    notifyListeners();
  }

  void setBreakDuration(int duration) {
    _breakDuration = duration * 60; // Convert minutes to seconds
    notifyListeners();
  }
}
