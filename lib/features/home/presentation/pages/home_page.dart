import 'package:flutter/material.dart';
import 'package:sc_aplikasi_za_time_qu/features/alarm/presentation/pages/alarm_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/clock/presentation/pages/clock_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/clock/presentation/pages/stopwatch_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/clock/presentation/pages/timer_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final pages = const [
    ClockPage(),
    StopwatchPage(),
    TimerPage(),
    AlarmPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(
          context,
        ).primaryColor.withValues(alpha: 0.4),
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Clock",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Stopwatch"),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_bottom),
            label: "Timer",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Alarm"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
