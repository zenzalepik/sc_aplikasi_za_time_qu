import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeService extends ChangeNotifier {
  // Reference to history service (will be set externally)
  Function(DateTime, Duration)? onStopwatchTick;
  static const String _prefStopwatchStart = 'stopwatch_start';
  static const String _prefStopwatchAccumulated = 'stopwatch_accumulated';
  static const String _prefStopwatchRunning = 'stopwatch_running';

  static const String _prefTimerEnd = 'timer_end';
  static const String _prefTimerRemaining = 'timer_remaining';
  static const String _prefTimerRunning = 'timer_running';
  static const String _prefTimerInitial = 'timer_initial';

  // Stopwatch State
  DateTime? _stopwatchStartTime;
  Duration _stopwatchAccumulated = Duration.zero;
  bool _stopwatchRunning = false;

  // Timer State
  DateTime? _timerEndTime;
  Duration _timerRemaining = const Duration(minutes: 1);
  Duration _timerInitial = const Duration(minutes: 1);
  bool _timerRunning = false;

  Timer? _ticker;

  bool get stopwatchRunning => _stopwatchRunning;
  bool get timerRunning => _timerRunning;
  Duration get timerInitial => _timerInitial;

  Duration get stopwatchElapsed {
    if (_stopwatchRunning && _stopwatchStartTime != null) {
      return DateTime.now().difference(_stopwatchStartTime!);
    }
    return _stopwatchAccumulated;
  }

  Duration get timerCurrentRemaining {
    if (_timerRunning && _timerEndTime != null) {
      final remaining = _timerEndTime!.difference(DateTime.now());
      return remaining.isNegative ? Duration.zero : remaining;
    }
    return _timerRemaining;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Stopwatch
    _stopwatchRunning = prefs.getBool(_prefStopwatchRunning) ?? false;
    final swStart = prefs.getInt(_prefStopwatchStart);
    final swAcc = prefs.getInt(_prefStopwatchAccumulated) ?? 0;

    _stopwatchAccumulated = Duration(milliseconds: swAcc);
    if (swStart != null) {
      _stopwatchStartTime = DateTime.fromMillisecondsSinceEpoch(swStart);
    }

    // Load Timer
    _timerRunning = prefs.getBool(_prefTimerRunning) ?? false;
    final tmEnd = prefs.getInt(_prefTimerEnd);
    final tmRem = prefs.getInt(_prefTimerRemaining);
    final tmInit = prefs.getInt(_prefTimerInitial);

    if (tmInit != null) {
      _timerInitial = Duration(milliseconds: tmInit);
    }
    if (tmRem != null) {
      _timerRemaining = Duration(milliseconds: tmRem);
    }
    if (tmEnd != null) {
      _timerEndTime = DateTime.fromMillisecondsSinceEpoch(tmEnd);
    }

    // If timer was running but expired while closed
    if (_timerRunning && _timerEndTime != null) {
      if (DateTime.now().isAfter(_timerEndTime!)) {
        _timerRunning = false;
        _timerRemaining = Duration.zero;
        _saveTimerState();
      }
    }

    _startTicker();
    notifyListeners();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_stopwatchRunning || _timerRunning) {
        if (_timerRunning && timerCurrentRemaining == Duration.zero) {
          stopTimer(); // Auto stop when done
        }

        // Auto-save stopwatch to history (every tick when running)
        if (_stopwatchRunning && onStopwatchTick != null) {
          final elapsed = stopwatchElapsed;
          if (elapsed > Duration.zero) {
            onStopwatchTick!(DateTime.now(), elapsed);
          }
        }

        notifyListeners();
      }
    });
  }

  // Stopwatch Methods
  Future<void> startStopwatch() async {
    if (_stopwatchRunning) return;

    // If we have accumulated time, we shift the start time back by that amount
    // so that (now - start) equals (accumulated + new_elapsed)
    // Actually, simpler: StartTime = Now - Accumulated.
    _stopwatchStartTime = DateTime.now().subtract(_stopwatchAccumulated);
    _stopwatchRunning = true;

    await _saveStopwatchState();
    notifyListeners();
  }

  Future<void> stopStopwatch() async {
    if (!_stopwatchRunning) return;

    _stopwatchAccumulated = stopwatchElapsed;
    _stopwatchStartTime = null;
    _stopwatchRunning = false;

    await _saveStopwatchState();
    notifyListeners();
  }

  Future<void> resetStopwatch() async {
    _stopwatchRunning = false;
    _stopwatchStartTime = null;
    _stopwatchAccumulated = Duration.zero;

    await _saveStopwatchState();
    notifyListeners();
  }

  Future<void> _saveStopwatchState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefStopwatchRunning, _stopwatchRunning);
    await prefs.setInt(
      _prefStopwatchAccumulated,
      _stopwatchAccumulated.inMilliseconds,
    );
    if (_stopwatchStartTime != null) {
      await prefs.setInt(
        _prefStopwatchStart,
        _stopwatchStartTime!.millisecondsSinceEpoch,
      );
    } else {
      await prefs.remove(_prefStopwatchStart);
    }
  }

  // Timer Methods
  void setTimerDuration(Duration duration) {
    _timerInitial = duration;
    _timerRemaining = duration;
    notifyListeners();
    _saveTimerState();
  }

  Future<void> startTimer() async {
    if (_timerRunning) return;

    if (_timerRemaining.inSeconds == 0) {
      _timerRemaining = _timerInitial;
    }

    _timerEndTime = DateTime.now().add(_timerRemaining);
    _timerRunning = true;

    await _saveTimerState();
    notifyListeners();
  }

  Future<void> stopTimer() async {
    if (!_timerRunning) return;

    _timerRemaining = timerCurrentRemaining;
    _timerEndTime = null;
    _timerRunning = false;

    await _saveTimerState();
    notifyListeners();
  }

  Future<void> resetTimer() async {
    _timerRunning = false;
    _timerEndTime = null;
    _timerRemaining = _timerInitial;

    await _saveTimerState();
    notifyListeners();
  }

  Future<void> _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefTimerRunning, _timerRunning);
    await prefs.setInt(_prefTimerRemaining, _timerRemaining.inMilliseconds);
    await prefs.setInt(_prefTimerInitial, _timerInitial.inMilliseconds);
    if (_timerEndTime != null) {
      await prefs.setInt(_prefTimerEnd, _timerEndTime!.millisecondsSinceEpoch);
    } else {
      await prefs.remove(_prefTimerEnd);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
