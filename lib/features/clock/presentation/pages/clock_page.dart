import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';
import '../../../../core/services/ui_service.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late Timer timer;
  String hourStr = "";
  String minuteStr = "";
  String secondStr = "";
  String date = "";
  String dayName = "";

  List<String> days = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  Map<int, Color> dayColors = {};

  int selectedDay = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
    loadColors();
    updateClock();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => updateClock());
  }

  Future<void> loadColors() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < 7; i++) {
        final colorValue = prefs.getInt('day_color_$i');
        if (colorValue != null) {
          dayColors[i] = Color(colorValue);
        }
      }
    });
  }

  Future<void> saveColor(int dayIndex, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('day_color_$dayIndex', color.value);
    setState(() {
      dayColors[dayIndex] = color;
    });
  }

  void updateClock() {
    final now = DateTime.now();
    setState(() {
      hourStr = two(now.hour);
      minuteStr = two(now.minute);
      secondStr = two(now.second);
      date = "${two(now.day)}-${two(now.month)}-${now.year}";
      dayName = days[now.weekday - 1];
    });
  }

  String two(int n) => n.toString().padLeft(2, "0");

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access TimeService without listening to avoid full rebuilds
    final timeService = Provider.of<TimeService>(context, listen: false);

    // Determine the color for the current day displayed
    final currentDayIndex = DateTime.now().weekday - 1;
    final currentDayColor = dayColors[currentDayIndex] ?? Colors.greenAccent;

    // Determine color for the selected day button
    final selectedDayColor = dayColors[selectedDay] ?? Colors.greenAccent;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: Text(
                dayName,
                style: GoogleFonts.ptSans(
                  color: currentDayColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: GestureDetector(
                onTap: () =>
                    showDialog(context: context, builder: (_) => daysDialog()),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selectedDayColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Pilih Hari: ${days[selectedDay]}",
                    style: GoogleFonts.ptSans(
                      color: Colors.black, // Contrast color for text
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Redesigned Clock Display
            Center(
              child: GestureDetector(
                onTap: () {
                  Provider.of<UIService>(context, listen: false).toggleNavbar();
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hourStr,
                          style: GoogleFonts.orbitron(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            height: 0.9,
                          ),
                        ),
                        Text(
                          minuteStr,
                          style: GoogleFonts.orbitron(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            height: 0.9,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      right: -40,
                      child: Text(
                        secondStr,
                        style: GoogleFonts.orbitron(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Center(child: Text(date, style: GoogleFonts.ptSans(fontSize: 26))),
            const SizedBox(height: 30),

            Container(
              height: 1,
              color: Colors.greenAccent.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 20),

            Text(
              "Stopwatch",
              style: GoogleFonts.ptSans(
                color: Colors.greenAccent,
                fontSize: 28,
              ),
            ),

            // Use Consumer to rebuild only this part when TimeService updates
            Consumer<TimeService>(
              builder: (context, timeService, child) {
                final sw = timeService.stopwatchElapsed;
                final swText =
                    "${two(sw.inMinutes)}:${two(sw.inSeconds % 60)}:${two((sw.inMilliseconds ~/ 10) % 100)}";
                return Center(
                  child: Text(swText, style: GoogleFonts.ptSans(fontSize: 50)),
                );
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use Selector to rebuild buttons only when running state changes
                Selector<TimeService, bool>(
                  selector: (_, service) => service.stopwatchRunning,
                  builder: (context, isRunning, child) {
                    return Row(
                      children: [
                        TextButton(
                          onPressed: isRunning
                              ? null
                              : timeService.startStopwatch,
                          child: Text("Start", style: GoogleFonts.ptSans()),
                        ),
                        TextButton(
                          onPressed: isRunning
                              ? timeService.stopStopwatch
                              : null,
                          child: Text("Stop", style: GoogleFonts.ptSans()),
                        ),
                      ],
                    );
                  },
                ),
                TextButton(
                  onPressed: timeService.resetStopwatch,
                  child: Text("Reset", style: GoogleFonts.ptSans()),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              height: 1,
              color: Colors.greenAccent.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 20),

            Text("Timer", style: GoogleFonts.ptSans(fontSize: 28)),

            // Use Consumer for Timer display
            Consumer<TimeService>(
              builder: (context, timeService, child) {
                final timerDuration = timeService.timerCurrentRemaining;
                final timerText =
                    "${two(timerDuration.inMinutes)}:${two(timerDuration.inSeconds % 60)}";
                return Center(
                  child: Text(
                    timerText,
                    style: GoogleFonts.ptSans(fontSize: 50),
                  ),
                );
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use Selector for Timer buttons
                Selector<TimeService, bool>(
                  selector: (_, service) => service.timerRunning,
                  builder: (context, isRunning, child) {
                    return Row(
                      children: [
                        TextButton(
                          onPressed: isRunning ? null : timeService.startTimer,
                          child: Text("Start", style: GoogleFonts.ptSans()),
                        ),
                        TextButton(
                          onPressed: isRunning ? timeService.stopTimer : null,
                          child: Text("Pause", style: GoogleFonts.ptSans()),
                        ),
                      ],
                    );
                  },
                ),
                TextButton(
                  onPressed: timeService.resetTimer,
                  child: Text("Reset", style: GoogleFonts.ptSans()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Dialog daysDialog() {
    return Dialog(
      backgroundColor: Colors.black,
      child: SizedBox(
        height: 330,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: days.length,
            itemBuilder: (_, i) {
              final dayColor = dayColors[i] ?? Colors.grey[800];
              return GestureDetector(
                onTap: () {
                  setState(() => selectedDay = i);
                  Navigator.pop(context); // Close day selection dialog
                  _showColorPicker(i); // Open color picker
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: dayColor,
                    borderRadius: BorderRadius.circular(10),
                    border: i == selectedDay
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    days[i],
                    style: GoogleFonts.ptSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showColorPicker(int dayIndex) {
    final List<Color> colors = [
      Colors.greenAccent,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.cyanAccent,
      Colors.white,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Pilih Warna untuk ${days[dayIndex]}",
                  style: GoogleFonts.ptSans(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: colors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        saveColor(dayIndex, color);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
