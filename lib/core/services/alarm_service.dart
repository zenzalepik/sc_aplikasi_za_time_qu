import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:sc_aplikasi_za_time_qu/features/alarm/data/models/alarm_model.dart';
import 'package:sc_aplikasi_za_time_qu/core/services/notification_service.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final NotificationService _notificationService = NotificationService();
  Timer? _checkTimer;
  Timer? _alarmTimer;
  Timer? _snoozeTimer;

  AlarmModel? _currentAlarm;
  bool _isRinging = false;
  int _ringDuration = 0; // dalam detik

  static const int maxRingDuration = 180; // 3 menit
  static const int snoozeInterval = 300; // 5 menit

  // Callbacks
  Function(AlarmModel)? onAlarmTriggered;
  Function()? onAlarmStopped;

  Future<void> initialize() async {
    await _notificationService.initialize();
    await _setupBeepSound();
    _startCheckingAlarms();
  }

  Future<void> _setupBeepSound() async {
    // Membuat suara beep menggunakan ByteData
    // Kita akan menggunakan suara dari assets jika ada, atau generate programatically
  }

  void _startCheckingAlarms() {
    // Check setiap 10 detik
    _checkTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkAlarms();
    });
  }

  Future<void> _checkAlarms() async {
    if (_isRinging) return;

    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString('alarms_data') ?? '[]';
    final List<dynamic> alarmsList = jsonDecode(alarmsJson);

    final now = DateTime.now();

    for (var alarmJson in alarmsList) {
      final alarm = AlarmModel.fromJson(alarmJson);

      if (!alarm.isEnabled) continue;

      if (alarm.hour == now.hour &&
          alarm.minute == now.minute &&
          now.second < 30) {
        // Check if should ring today
        final weekday = now.weekday - 1; // 0 = Monday
        if (alarm.repeatDays.every((day) => !day) ||
            alarm.repeatDays[weekday]) {
          await _triggerAlarm(alarm);
          break;
        }
      }
    }
  }

  Future<void> _triggerAlarm(AlarmModel alarm) async {
    _isRinging = true;
    _currentAlarm = alarm;
    _ringDuration = 0;

    onAlarmTriggered?.call(alarm);

    // Mulai suara dan vibrasi
    await _startRinging();

    // Timer untuk auto-stop setelah 3 menit
    _alarmTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _ringDuration++;

      if (_ringDuration >= maxRingDuration) {
        timer.cancel();
        stopAlarm(autoSnooze: true);
      }
    });
  }

  Future<void> _startRinging() async {
    // Play beep sound dengan loop
    await _playBeepSound();

    // Vibrasi panjang dengan pattern
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      // Pattern: [delay, vibrate, delay, vibrate, ...]
      // 500ms on, 200ms off, repeat
      Vibration.vibrate(
        pattern: [0, 500, 200, 500, 200, 500, 200],
        repeat: 0, // 0 means repeat indefinitely
      );
    }
  }

  Future<void> _playBeepSound() async {
    try {
      // Menggunakan loop untuk memutar system sound berulang kali
      // Ini akan menciptakan efek beep-beep yang konsisten
      _playSystemBeep();
    } catch (e) {
      print('Error playing alarm sound: $e');
      _playSystemBeep();
    }
  }

  Timer? _beepTimer;

  void _playSystemBeep() {
    // Membuat pattern beep: beep-beep-pause-beep-beep
    int beepCount = 0;

    _beepTimer?.cancel();
    _beepTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!_isRinging) {
        timer.cancel();
        return;
      }

      // Pattern: 2 beeps, pause, repeat
      if (beepCount % 3 != 2) {
        SystemSound.play(SystemSoundType.alert);
      }

      beepCount++;
    });
  }

  Future<void> stopAlarm({bool autoSnooze = false}) async {
    _isRinging = false;
    _alarmTimer?.cancel();
    _beepTimer?.cancel();

    // Stop audio
    await _audioPlayer.stop();

    // Stop vibration
    await Vibration.cancel();

    if (autoSnooze && _currentAlarm != null) {
      // Set timer untuk snooze (restart after 5 minutes)
      _snoozeTimer = Timer(const Duration(seconds: snoozeInterval), () {
        if (_currentAlarm != null) {
          _triggerAlarm(_currentAlarm!);
        }
      });
    } else {
      // Re-schedule notifications for repeating alarms
      if (_currentAlarm != null &&
          _currentAlarm!.repeatDays.any((day) => day)) {
        await _scheduleAlarmNotifications(_currentAlarm!);
      }
      _currentAlarm = null;
    }

    onAlarmStopped?.call();
  }

  Future<List<AlarmModel>> getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString('alarms_data') ?? '[]';
    final List<dynamic> alarmsList = jsonDecode(alarmsJson);

    return alarmsList.map((json) => AlarmModel.fromJson(json)).toList();
  }

  Future<void> saveAlarms(List<AlarmModel> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = jsonEncode(alarms.map((a) => a.toJson()).toList());
    await prefs.setString('alarms_data', alarmsJson);
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    final alarms = await getAlarms();
    alarms.add(alarm);
    await saveAlarms(alarms);

    // Schedule notifications if alarm is enabled
    if (alarm.isEnabled) {
      await _scheduleAlarmNotifications(alarm);
    }
  }

  Future<void> updateAlarm(String id, AlarmModel updatedAlarm) async {
    final alarms = await getAlarms();
    final index = alarms.indexWhere((a) => a.id == id);
    if (index != -1) {
      alarms[index] = updatedAlarm;
      await saveAlarms(alarms);

      // Cancel old notifications and schedule new ones if enabled
      await _notificationService.cancelAlarmNotifications(id);
      if (updatedAlarm.isEnabled) {
        await _scheduleAlarmNotifications(updatedAlarm);
      }
    }
  }

  Future<void> deleteAlarm(String id) async {
    // Cancel notifications first
    await _notificationService.cancelAlarmNotifications(id);

    // Stop alarm if it's currently ringing
    if (_currentAlarm?.id == id && _isRinging) {
      await stopAlarm(autoSnooze: false);
    }

    // Cancel snooze timer if this is the snoozed alarm
    if (_currentAlarm?.id == id) {
      _snoozeTimer?.cancel();
      _currentAlarm = null;
    }

    final alarms = await getAlarms();
    alarms.removeWhere((a) => a.id == id);
    await saveAlarms(alarms);
  }

  Future<void> toggleAlarm(String id, bool enabled) async {
    final alarms = await getAlarms();
    final index = alarms.indexWhere((a) => a.id == id);
    if (index != -1) {
      final alarm = alarms[index].copyWith(isEnabled: enabled);
      alarms[index] = alarm;
      await saveAlarms(alarms);

      // Manage notifications based on enabled state
      if (enabled) {
        await _scheduleAlarmNotifications(alarm);
      } else {
        await _notificationService.cancelAlarmNotifications(id);
      }
    }
  }

  bool get isRinging => _isRinging;
  AlarmModel? get currentAlarm => _currentAlarm;

  /// Schedule notifications for an alarm
  Future<void> _scheduleAlarmNotifications(AlarmModel alarm) async {
    final now = DateTime.now();

    // Calculate next alarm time
    DateTime nextAlarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.hour,
      alarm.minute,
    );

    // If alarm time has passed today, move to tomorrow
    if (nextAlarmTime.isBefore(now) ||
        (nextAlarmTime.hour == now.hour &&
            nextAlarmTime.minute == now.minute)) {
      nextAlarmTime = nextAlarmTime.add(const Duration(days: 1));
    }

    // If alarm has repeat days, find the next valid day
    if (alarm.repeatDays.any((day) => day)) {
      while (!_shouldAlarmRingOnDay(alarm, nextAlarmTime)) {
        nextAlarmTime = nextAlarmTime.add(const Duration(days: 1));
      }
    }

    // Schedule notifications
    await _notificationService.scheduleAlarmNotifications(
      alarmId: alarm.id,
      alarmTime: nextAlarmTime,
      label: alarm.label,
    );
  }

  /// Check if alarm should ring on a specific day
  bool _shouldAlarmRingOnDay(AlarmModel alarm, DateTime date) {
    // If no repeat days set, alarm should ring once
    if (alarm.repeatDays.every((day) => !day)) {
      return true;
    }

    // Check if the day of week matches
    final weekday = date.weekday - 1; // 0 = Monday
    return alarm.repeatDays[weekday];
  }

  void dispose() {
    _checkTimer?.cancel();
    _alarmTimer?.cancel();
    _snoozeTimer?.cancel();
    _audioPlayer.dispose();
  }
}
