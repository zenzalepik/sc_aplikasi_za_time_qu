import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sc_aplikasi_za_time_qu/features/alarm/presentation/pages/alarm_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/clock/presentation/pages/clock_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/clock/presentation/pages/stopwatch_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/clock/presentation/pages/timer_page.dart';
import 'package:sc_aplikasi_za_time_qu/features/settings/presentation/pages/settings_page.dart';
import '../../../../core/services/ui_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
    final uiService = Provider.of<UIService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: pages[index],
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: uiService.isNavbarVisible
            ? kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom
            : 0,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.4),
            type: BottomNavigationBarType.fixed,
            currentIndex: index,
            onTap: (i) => setState(() => index = i),
            selectedLabelStyle: TextStyle(fontSize: 11), // ← Teks terpilih
            unselectedLabelStyle: TextStyle(
              fontSize: 9,
            ), // ← Teks tidak terpilih
            items: [
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.clock),
                label: "Clock",
              ),
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.stopwatch_solid),
                label: "Stopwatch",
              ),
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.hourglass),
                label: "Timer",
              ),
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.bell),
                label: "Alarm",
              ),
              BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.cog_solid),
                label: "Settings",
              ),
            ],
            /*const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.clock), // 🕒
                label: "Clock",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.stopwatch), // ⏱️
                label: "Stopwatch",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.hourglass), // ⌛
                label: "Timer",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.bell), // 🔔
                label: "Alarm",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.gear), // ⚙️
                label: "Settings",
              ),
            ],*/
            //const [
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.access_time_outlined),
            //     label: "Clock",
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.timer_outlined),
            //     label: "Stopwatch",
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.hourglass_bottom_outlined),
            //     label: "Timer",
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.alarm_add_outlined),
            //     label: "Alarm",
            //   ),
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.settings_outlined),
            //     label: "Settings",
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}
