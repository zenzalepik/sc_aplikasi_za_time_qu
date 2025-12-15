import 'package:flutter/material.dart';
import 'package:sc_aplikasi_za_time_qu/core/services/alarm_service.dart';
import 'package:sc_aplikasi_za_time_qu/features/alarm/data/models/alarm_model.dart';
import 'package:sc_aplikasi_za_time_qu/features/alarm/presentation/pages/alarm_ringing_screen.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final AlarmService _alarmService = AlarmService();
  List<AlarmModel> alarms = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAlarmService();
    loadAlarms();
  }

  Future<void> _initializeAlarmService() async {
    if (!_initialized) {
      await _alarmService.initialize();

      _alarmService.onAlarmTriggered = (alarm) {
        _showAlarmRingingScreen(alarm);
      };

      _alarmService.onAlarmStopped = () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      };

      _initialized = true;
    }
  }

  void _showAlarmRingingScreen(AlarmModel alarm) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AlarmRingingScreen(
          alarmTime: alarm.timeString,
          alarmLabel: alarm.label,
          onStop: () {
            _alarmService.stopAlarm(autoSnooze: false);
          },
          onSnooze: () {
            _alarmService.stopAlarm(autoSnooze: true);
          },
        ),
      ),
    );
  }

  Future<void> loadAlarms() async {
    final loadedAlarms = await _alarmService.getAlarms();
    setState(() {
      alarms = loadedAlarms;
    });
  }

  Future<void> addAlarm() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final newAlarm = AlarmModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        hour: picked.hour,
        minute: picked.minute,
        isEnabled: true,
      );

      await _alarmService.addAlarm(newAlarm);
      await loadAlarms();
    }
  }

  Future<void> deleteAlarm(String id) async {
    await _alarmService.deleteAlarm(id);
    await loadAlarms();
  }

  Future<void> toggleAlarm(String id, bool value) async {
    await _alarmService.toggleAlarm(id, value);
    await loadAlarms();
  }

  String _getRepeatDaysText(List<bool> repeatDays) {
    if (repeatDays.every((day) => !day)) {
      return 'Sekali';
    }

    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final activeDays = <String>[];

    for (int i = 0; i < repeatDays.length; i++) {
      if (repeatDays[i]) {
        activeDays.add(days[i]);
      }
    }

    if (activeDays.length == 7) {
      return 'Setiap hari';
    }

    return activeDays.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: addAlarm,
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      body: alarms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm_add,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tidak ada alarm',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan + untuk menambah alarm',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: alarms.length,
              itemBuilder: (_, i) {
                final alarm = alarms[i];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: alarm.isEnabled
                        ? Colors.greenAccent.withOpacity(0.1)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: alarm.isEnabled
                          ? Colors.greenAccent.withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alarm.timeString,
                                style: TextStyle(
                                  color: alarm.isEnabled
                                      ? Colors.greenAccent
                                      : Colors.white.withOpacity(0.3),
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getRepeatDaysText(alarm.repeatDays),
                                style: TextStyle(
                                  color: alarm.isEnabled
                                      ? Colors.white70
                                      : Colors.white.withOpacity(0.2),
                                  fontSize: 14,
                                ),
                              ),
                              if (alarm.label.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  alarm.label,
                                  style: TextStyle(
                                    color: alarm.isEnabled
                                        ? Colors.white60
                                        : Colors.white.withOpacity(0.2),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Switch(
                              value: alarm.isEnabled,
                              onChanged: (value) {
                                toggleAlarm(alarm.id, value);
                              },
                              activeColor: Colors.greenAccent,
                              inactiveThumbColor: Colors.white54,
                              inactiveTrackColor: Colors.white12,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.white54,
                              ),
                              onPressed: () {
                                deleteAlarm(alarm.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    // Don't dispose the service as it needs to run in background
    super.dispose();
  }
}
