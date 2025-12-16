import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Find local timezone (default to Jakarta if not found)
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    } catch (e) {
      // If timezone not found, use UTC
      tz.setLocalLocation(tz.UTC);
    }

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    if (await _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ==
        false) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap if needed
    // You can add navigation logic here
  }

  /// Schedule notifications for alarm
  /// - 1 hour before
  /// - 10 minutes before
  Future<void> scheduleAlarmNotifications({
    required String alarmId,
    required DateTime alarmTime,
    required String label,
  }) async {
    await initialize();

    final now = DateTime.now();

    // Calculate notification times
    final oneHourBefore = alarmTime.subtract(const Duration(hours: 1));
    final tenMinutesBefore = alarmTime.subtract(const Duration(minutes: 10));

    // Schedule 1 hour notification
    if (oneHourBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _getNotificationId(alarmId, '1h'),
        title: 'Pengingat Alarm',
        body: label.isEmpty
            ? '1 jam lagi alarm akan berbunyi'
            : '$label - 1 jam lagi',
        scheduledTime: oneHourBefore,
      );
    }

    // Schedule 10 minutes notification
    if (tenMinutesBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _getNotificationId(alarmId, '10m'),
        title: 'Pengingat Alarm',
        body: label.isEmpty
            ? '10 menit lagi alarm akan berbunyi'
            : '$label - 10 menit lagi',
        scheduledTime: tenMinutesBefore,
      );
    }
  }

  /// Schedule notifications for timer
  /// - 1 hour before timer ends
  /// - 10 minutes before timer ends
  Future<void> scheduleTimerNotifications({
    required String timerId,
    required DateTime endTime,
    String? label,
  }) async {
    await initialize();

    final now = DateTime.now();

    // Calculate notification times
    final oneHourBefore = endTime.subtract(const Duration(hours: 1));
    final tenMinutesBefore = endTime.subtract(const Duration(minutes: 10));

    // Schedule 1 hour notification
    if (oneHourBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _getNotificationId(timerId, '1h'),
        title: 'Pengingat Timer',
        body: label ?? '1 jam lagi timer akan selesai',
        scheduledTime: oneHourBefore,
      );
    }

    // Schedule 10 minutes notification
    if (tenMinutesBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _getNotificationId(timerId, '10m'),
        title: 'Pengingat Timer',
        body: label ?? '10 menit lagi timer akan selesai',
        scheduledTime: tenMinutesBefore,
      );
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_timer_channel',
      'Alarm & Timer',
      channelDescription: 'Notifikasi untuk alarm dan timer',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel all notifications for a specific alarm
  Future<void> cancelAlarmNotifications(String alarmId) async {
    await _notifications.cancel(_getNotificationId(alarmId, '1h'));
    await _notifications.cancel(_getNotificationId(alarmId, '10m'));
  }

  /// Cancel all notifications for a specific timer
  Future<void> cancelTimerNotifications(String timerId) async {
    await _notifications.cancel(_getNotificationId(timerId, '1h'));
    await _notifications.cancel(_getNotificationId(timerId, '10m'));
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Generate unique notification ID from alarm/timer ID and type
  int _getNotificationId(String itemId, String type) {
    // Create a unique int ID from string
    // Using hashCode to convert string to int
    final combined = '$itemId-$type';
    return combined.hashCode.abs() % 2147483647; // Max int32 value
  }

  /// Show immediate notification (for testing or instant alerts)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'alarm_timer_channel',
      'Alarm & Timer',
      channelDescription: 'Notifikasi untuk alarm dan timer',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
  }
}
