import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/daily_stopwatch_record.dart';

/// Service untuk manage stopwatch history dan settings
class StopwatchHistoryService extends ChangeNotifier {
  static const String _prefHistoryKey = 'stopwatch_history';
  static const String _prefTargetHours = 'stopwatch_target_hours';
  static const String _prefColorThresholds = 'stopwatch_color_thresholds';

  // Default target: 8 jam
  double _targetHours = 8.0;

  // Default color thresholds (dalam jam)
  Map<String, double> _colorThresholds = {
    'green': 8.0, // >= 8 jam
    'purple': 7.0, // 7-8 jam
    'blue': 6.0, // 6-7 jam
    'orange': 4.0, // 4-6 jam
    'yellow': 0.0, // 0-4 jam (> 0)
  };

  Map<String, DailyStopwatchRecord> _records = {};

  double get targetHours => _targetHours;
  Map<String, double> get colorThresholds => Map.from(_colorThresholds);
  Map<String, DailyStopwatchRecord> get records => Map.from(_records);

  /// Initialize service
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load target hours
    _targetHours = prefs.getDouble(_prefTargetHours) ?? 8.0;

    // Load color thresholds
    final thresholdsJson = prefs.getString(_prefColorThresholds);
    if (thresholdsJson != null) {
      final decoded = jsonDecode(thresholdsJson) as Map<String, dynamic>;
      _colorThresholds = decoded.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
    }

    // Load history
    final historyJson = prefs.getString(_prefHistoryKey);
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      _records = {
        for (var item in decoded)
          (item['date'] as String): DailyStopwatchRecord.fromJson(item),
      };
    }

    notifyListeners();
  }

  /// Save history to SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_records.values.map((r) => r.toJson()).toList());
    await prefs.setString(_prefHistoryKey, encoded);
  }

  /// Add or update duration for a specific date
  Future<void> addDuration(DateTime date, Duration duration) async {
    final dateKey = _getDateKey(date);

    if (_records.containsKey(dateKey)) {
      final existing = _records[dateKey]!;
      _records[dateKey] = DailyStopwatchRecord(
        date: existing.date,
        totalDuration: existing.totalDuration + duration,
      );
    } else {
      _records[dateKey] = DailyStopwatchRecord(
        date: DateTime(date.year, date.month, date.day),
        totalDuration: duration,
      );
    }

    await _saveHistory();
    notifyListeners();
  }

  /// Manually set duration for a specific date (with warning)
  Future<void> setDuration(DateTime date, Duration duration) async {
    final dateKey = _getDateKey(date);

    _records[dateKey] = DailyStopwatchRecord(
      date: DateTime(date.year, date.month, date.day),
      totalDuration: duration,
    );

    await _saveHistory();
    notifyListeners();
  }

  /// Get duration for a specific date
  Duration getDuration(DateTime date) {
    final dateKey = _getDateKey(date);
    return _records[dateKey]?.totalDuration ?? Duration.zero;
  }

  /// Get color for a specific date based on thresholds
  Color? getColorForDate(DateTime date) {
    final duration = getDuration(date);
    final hours = duration.inSeconds / 3600;

    if (hours == 0) return null;
    if (hours >= _colorThresholds['green']!) return Colors.green;
    if (hours >= _colorThresholds['purple']!) return Colors.purple;
    if (hours >= _colorThresholds['blue']!) return Colors.blue;
    if (hours >= _colorThresholds['orange']!) return Colors.orange;
    if (hours > 0) return Colors.yellow;

    return null;
  }

  /// Update target hours
  Future<void> setTargetHours(double hours) async {
    _targetHours = hours;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefTargetHours, hours);
    notifyListeners();
  }

  /// Update color threshold
  Future<void> setColorThreshold(String colorKey, double hours) async {
    _colorThresholds[colorKey] = hours;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefColorThresholds, jsonEncode(_colorThresholds));
    notifyListeners();
  }

  /// Get date key string
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get all dates in a month that have records
  List<DateTime> getDatesInMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    List<DateTime> dates = [];
    for (int day = 1; day <= lastDay.day; day++) {
      dates.add(DateTime(year, month, day));
    }

    return dates;
  }
}
