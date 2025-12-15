import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/ui_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/services/system_ui_service.dart';
import '../../../../widgets/second_display.dart';
import '../../../../widgets/date_label_positioned.dart';
import '../../../../widgets/stopwatch_display.dart';
import '../../../../widgets/timer_display.dart';
import '../../../../widgets/clock_separator.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          SystemUIService.toggleSystemUI();
        },
        color: themeService.primaryColor,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(
                      context,
                    ).size.height, // ← Tinggi layar minimum
                    maxHeight: MediaQuery.of(
                      context,
                    ).size.height, // ← Tinggi layar maksimal
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // ← Penting
                      children: [
                        // Main clock display
                        Expanded(
                          child: GestureDetector(
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
                                    final isLandscape =
                                        screenWidth > screenHeight;

                                    // Card builder helper
                                    Widget buildCard(
                                      String value, {
                                      Widget? secondWidget,
                                      Widget? dateWidget,
                                      Widget? stopWatchWidget,
                                    }) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        themeService.cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      value,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: themeService
                                                          .getPrimaryTextStyle(
                                                            fontSize: themeService
                                                                .clockFontSize,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            height: 0.9,
                                                            color: themeService
                                                                .primaryColor,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                if (dateWidget != null)
                                                  dateWidget,
                                                if (secondWidget != null)
                                                  secondWidget,
                                                if (stopWatchWidget != null)
                                                  stopWatchWidget,
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    // Horizontal layout for landscape (width > height)
                                    if (isLandscape) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: buildCard(
                                              hourStr,
                                              dateWidget: DateLabelPositioned(
                                                themeService: themeService,
                                                dayName: dayName,
                                                date: date,
                                                currentDayColor:
                                                    currentDayColor,
                                                onDayTap: () => _showDaysDialog(
                                                  themeService,
                                                ),
                                                left: 0,
                                                right: 0,
                                              ),
                                            ),
                                          ),
                                          // const SizedBox(width: 10),
                                          // Separator ":"
                                          ClockSeparator(
                                            themeService: themeService,
                                          ),
                                          Expanded(
                                            child: buildCard(
                                              minuteStr,
                                              secondWidget: SecondDisplay(
                                                secondStr: secondStr,
                                                themeService: themeService,
                                              ),
                                              stopWatchWidget:
                                                  // Conditionally show Stopwatch section
                                                  themeService.showStopwatch
                                                  ? Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: StopwatchDisplay(),
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      );
                                    }

                                    // Vertical layout for portrait (height > width)
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: buildCard(
                                            hourStr,
                                            dateWidget: DateLabelPositioned(
                                              themeService: themeService,
                                              dayName: dayName,
                                              date: date,
                                              currentDayColor: currentDayColor,
                                              onDayTap: () =>
                                                  _showDaysDialog(themeService),
                                              left: 0,
                                              right: 0,
                                            ),
                                          ),
                                        ),
                                        // const SizedBox(height: 10),
                                        ClockSeparator(
                                          themeService: themeService,
                                          rotateVertical: true,
                                        ),
                                        Expanded(
                                          child: buildCard(
                                            minuteStr,
                                            secondWidget: SecondDisplay(
                                              secondStr: secondStr,
                                              themeService: themeService,
                                            ),
                                            stopWatchWidget:
                                                // Conditionally show Stopwatch section
                                                themeService.showStopwatch
                                                ? Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: StopwatchDisplay(),
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Conditionally show Timer section
                        if (themeService.showTimer) TimerDisplay(),
                      ],
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
