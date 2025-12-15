import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';
import '../../../../core/services/ui_service.dart';
import '../../../../core/services/theme_service.dart';

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
    final timeService = Provider.of<TimeService>(context, listen: false);
    final themeService = Provider.of<ThemeService>(context);

    // Determine the color for the current day displayed
    final currentDayIndex = DateTime.now().weekday - 1;
    final currentDayColor =
        dayColors[currentDayIndex] ?? themeService.primaryColor;

    // Determine color for the selected day button
    final selectedDayColor =
        dayColors[selectedDay] ?? themeService.primaryColor;

    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(
                    context,
                  ).size.height, // ← Tinggi layar
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // ← Penting
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Day name with color indicator
                          if (themeService.showDay)
                            GestureDetector(
                              onTap: () {
                                _showDaysDialog(themeService);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: currentDayColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: currentDayColor,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: currentDayColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      dayName,
                                      style: themeService.getSecondaryTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: currentDayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (themeService.showDay && themeService.showDate)
                            const SizedBox(width: 12),

                          // Conditionally show date
                          if (themeService.showDate)
                            Center(
                              child: Text(
                                date,
                                style: themeService.getSecondaryTextStyle(
                                  fontSize: 12,
                                  color: themeService.primaryColor,
                                ),
                              ),
                            ),
                          if (themeService.showDate) const SizedBox(height: 12),
                        ],
                      ),

                      // Main clock display
                      GestureDetector(
                        onTap: () {
                          Provider.of<UIService>(
                            context,
                            listen: false,
                          ).toggleNavbar();
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Responsive layout based on screen orientation
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final screenWidth = MediaQuery.of(
                                  context,
                                ).size.width;
                                final screenHeight = MediaQuery.of(
                                  context,
                                ).size.height;
                                final isLandscape = screenWidth > screenHeight;

                                // Card builder helper
                                Widget buildCard(String value) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 96,
                                          ),
                                          decoration: BoxDecoration(
                                            color: themeService.cardColor,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: themeService
                                                .getPrimaryTextStyle(
                                                  fontSize: 150,
                                                  fontWeight: FontWeight.bold,
                                                  height: 0.9,
                                                  color:
                                                      themeService.primaryColor,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Horizontal layout for landscape (width > height)
                                if (isLandscape) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: buildCard(hourStr)),
                                      const SizedBox(width: 10),
                                      Expanded(child: buildCard(minuteStr)),
                                    ],
                                  );
                                }

                                // Vertical layout for portrait (height > width)
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildCard(hourStr),
                                    const SizedBox(height: 10),
                                    buildCard(minuteStr),
                                  ],
                                );
                              },
                            ),
                            Positioned(
                              bottom: -48,
                              right: 40,
                              child: Text(
                                secondStr,
                                style: themeService.getPrimaryTextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeService.primaryColor.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Conditionally show Stopwatch section
                      if (themeService.showStopwatch
                      // && !themeService.showTimer
                      )
                        Consumer<TimeService>(
                          builder: (context, ts, child) {
                            if (ts.stopwatchElapsed > Duration.zero) {
                              final sw = ts.stopwatchElapsed;
                              final swText =
                                  "${two(sw.inMinutes.remainder(60))}:${two(sw.inSeconds.remainder(60))}:${two((sw.inMilliseconds ~/ 10) % 100)}";

                              return Column(
                                children: [
                                  Container(
                                    height: 1,
                                    color: themeService.primaryColor
                                        .withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Stopwatch",
                                    style: themeService.getSecondaryTextStyle(
                                      color: themeService.primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),

                                  Center(
                                    child: Text(
                                      swText,
                                      style: themeService.getSecondaryTextStyle(
                                        fontSize: 50,
                                        color: themeService.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Selector<TimeService, bool>(
                                        selector: (_, service) =>
                                            service.stopwatchRunning,
                                        builder: (context, isRunning, child) {
                                          return Row(
                                            children: [
                                              TextButton(
                                                onPressed: isRunning
                                                    ? null
                                                    : timeService
                                                          .startStopwatch,
                                                child: Text(
                                                  "Start",
                                                  style: themeService
                                                      .getSecondaryTextStyle(
                                                        color: themeService
                                                            .primaryColor,
                                                      ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: isRunning
                                                    ? timeService.stopStopwatch
                                                    : null,
                                                child: Text(
                                                  "Stop",
                                                  style: themeService
                                                      .getSecondaryTextStyle(
                                                        color: themeService
                                                            .primaryColor,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      TextButton(
                                        onPressed: timeService.resetStopwatch,
                                        child: Text(
                                          "Reset",
                                          style: themeService
                                              .getSecondaryTextStyle(
                                                color:
                                                    themeService.primaryColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                      // Conditionally show Timer section
                      if (themeService.showTimer
                      // && !themeService.showStopwatch
                      )
                        Consumer<TimeService>(
                          builder: (context, ts, child) {
                            if (ts.timerCurrentRemaining > Duration.zero) {
                              final timerDuration = ts.timerCurrentRemaining;
                              final timerText =
                                  "${two(timerDuration.inMinutes.remainder(60))}:${two(timerDuration.inSeconds.remainder(60))}";

                              return Column(
                                children: [
                                  Container(
                                    height: 1,
                                    color: themeService.primaryColor
                                        .withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Timer",
                                    style: themeService.getSecondaryTextStyle(
                                      fontSize: 16,
                                      color: themeService.primaryColor,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      timerText,
                                      style: themeService.getSecondaryTextStyle(
                                        fontSize: 50,
                                        color: themeService.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Selector<TimeService, bool>(
                                        selector: (_, service) =>
                                            service.timerRunning,
                                        builder: (context, isRunning, child) {
                                          return Row(
                                            children: [
                                              TextButton(
                                                onPressed: isRunning
                                                    ? null
                                                    : timeService.startTimer,
                                                child: Text(
                                                  "Start",
                                                  style: themeService
                                                      .getSecondaryTextStyle(
                                                        color: themeService
                                                            .primaryColor,
                                                      ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: isRunning
                                                    ? timeService.stopTimer
                                                    : null,
                                                child: Text(
                                                  "Pause",
                                                  style: themeService
                                                      .getSecondaryTextStyle(
                                                        color: themeService
                                                            .primaryColor,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      TextButton(
                                        onPressed: timeService.resetTimer,
                                        child: Text(
                                          "Reset",
                                          style: themeService
                                              .getSecondaryTextStyle(
                                                color:
                                                    themeService.primaryColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDaysDialog(ThemeService themeService) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: themeService.backgroundColor,
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
                    _showColorPicker(i, themeService); // Open color picker
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
                      style: themeService.getSecondaryTextStyle(
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
      ),
    );
  }

  void _showColorPicker(int dayIndex, ThemeService themeService) {
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
          backgroundColor: themeService.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Pilih Warna untuk ${days[dayIndex]}",
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor,
                    fontSize: 18,
                  ),
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
