import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/stopwatch_history_service.dart';
import '../../../../core/services/theme_service.dart';

class StopwatchHistoryPage extends StatefulWidget {
  const StopwatchHistoryPage({super.key});

  @override
  State<StopwatchHistoryPage> createState() => _StopwatchHistoryPageState();
}

class _StopwatchHistoryPageState extends State<StopwatchHistoryPage> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final historyService = Provider.of<StopwatchHistoryService>(context);

    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Stopwatch History',
          style: themeService.getSecondaryTextStyle(
            color: themeService.primaryColor,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: themeService.primaryColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                _showSettingsDialog(context, historyService, themeService),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar grid - centered vertically
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: _buildCalendarGrid(historyService, themeService),
                ),
              ),
            ),
          ),

          // Month navigation - above legend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: themeService.primaryColor,
                  ),
                  onPressed: _previousMonth,
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: themeService.primaryColor,
                  ),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),

          // Color legend at bottom
          _buildColorLegend(themeService, historyService),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildColorLegend(
    ThemeService themeService,
    StopwatchHistoryService historyService,
  ) {
    final thresholds = historyService.colorThresholds;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend:',
            style: themeService.getSecondaryTextStyle(
              color: themeService.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                Colors.green,
                '>= ${thresholds['green']!.toStringAsFixed(0)}h',
                themeService,
              ),
              _buildLegendItem(
                Colors.purple,
                '${thresholds['purple']!.toStringAsFixed(0)}-${thresholds['green']!.toStringAsFixed(0)}h',
                themeService,
              ),
              _buildLegendItem(
                Colors.blue,
                '${thresholds['blue']!.toStringAsFixed(0)}-${thresholds['purple']!.toStringAsFixed(0)}h',
                themeService,
              ),
              _buildLegendItem(
                Colors.orange,
                '${thresholds['orange']!.toStringAsFixed(0)}-${thresholds['blue']!.toStringAsFixed(0)}h',
                themeService,
              ),
              _buildLegendItem(
                Colors.yellow,
                '0-${thresholds['orange']!.toStringAsFixed(0)}h',
                themeService,
              ),
              _buildLegendItem(Colors.grey, '0h', themeService),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    Color color,
    String label,
    ThemeService themeService,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: themeService.getSecondaryTextStyle(
            color: themeService.primaryColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(
    StopwatchHistoryService historyService,
    ThemeService themeService,
  ) {
    final dates = historyService.getDatesInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    final firstDayWeekday = dates.first.weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: dates.length + (firstDayWeekday % 7),
      itemBuilder: (context, index) {
        if (index < firstDayWeekday % 7) {
          return const SizedBox();
        }

        final dateIndex = index - (firstDayWeekday % 7);
        final date = dates[dateIndex];
        final duration = historyService.getDuration(date);
        final color = historyService.getColorForDate(date);

        return GestureDetector(
          onTap: () => _showEditDialog(
            context,
            date,
            duration,
            historyService,
            themeService,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color ?? Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeService.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: themeService.getSecondaryTextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (duration.inSeconds > 0)
                  Text(
                    '${(duration.inSeconds / 3600).toStringAsFixed(1)}h',
                    style: themeService.getSecondaryTextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    DateTime date,
    Duration currentDuration,
    StopwatchHistoryService historyService,
    ThemeService themeService,
  ) {
    final hoursController = TextEditingController(
      text: (currentDuration.inSeconds ~/ 3600).toString(),
    );
    final minutesController = TextEditingController(
      text: ((currentDuration.inSeconds % 3600) ~/ 60).toString(),
    );
    final secondsController = TextEditingController(
      text: (currentDuration.inSeconds % 60).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeService.backgroundColor,
        title: Text(
          'Edit Stopwatch Data',
          style: themeService.getSecondaryTextStyle(
            color: themeService.primaryColor,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Date: ${date.day}/${date.month}/${date.year}',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[900]?.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'WARNING: This is important data. Please be honest!',
                      style: themeService.getSecondaryTextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    style: themeService.getSecondaryTextStyle(
                      color: themeService.primaryColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Hours',
                      labelStyle: themeService.getSecondaryTextStyle(
                        color: themeService.primaryColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    style: themeService.getSecondaryTextStyle(
                      color: themeService.primaryColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                      labelStyle: themeService.getSecondaryTextStyle(
                        color: themeService.primaryColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: secondsController,
                    keyboardType: TextInputType.number,
                    style: themeService.getSecondaryTextStyle(
                      color: themeService.primaryColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Seconds',
                      labelStyle: themeService.getSecondaryTextStyle(
                        color: themeService.primaryColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final hours = int.tryParse(hoursController.text) ?? 0;
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final seconds = int.tryParse(secondsController.text) ?? 0;

              final newDuration = Duration(
                hours: hours,
                minutes: minutes,
                seconds: seconds,
              );

              historyService.setDuration(date, newDuration);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeService.primaryColor,
              foregroundColor: Colors.black,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(
    BuildContext context,
    StopwatchHistoryService historyService,
    ThemeService themeService,
  ) {
    final targetController = TextEditingController(
      text: historyService.targetHours.toStringAsFixed(1),
    );

    final thresholds = Map<String, TextEditingController>.fromEntries(
      historyService.colorThresholds.entries.map(
        (e) => MapEntry(
          e.key,
          TextEditingController(text: e.value.toStringAsFixed(1)),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeService.backgroundColor,
        title: Text(
          'Settings',
          style: themeService.getSecondaryTextStyle(
            color: themeService.primaryColor,
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Target Hours per Day:',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
                decoration: InputDecoration(
                  suffix: Text(
                    'hours',
                    style: themeService.getSecondaryTextStyle(
                      color: themeService.primaryColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Color Thresholds (hours):',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildThresholdField(
                'Green (>= hours)',
                Colors.green,
                thresholds['green']!,
                themeService,
              ),
              _buildThresholdField(
                'Purple (>= hours)',
                Colors.purple,
                thresholds['purple']!,
                themeService,
              ),
              _buildThresholdField(
                'Blue (>= hours)',
                Colors.blue,
                thresholds['blue']!,
                themeService,
              ),
              _buildThresholdField(
                'Orange (>= hours)',
                Colors.orange,
                thresholds['orange']!,
                themeService,
              ),
              _buildThresholdField(
                'Yellow (> 0 hours)',
                Colors.yellow,
                thresholds['yellow']!,
                themeService,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final target = double.tryParse(targetController.text) ?? 8.0;
              historyService.setTargetHours(target);

              thresholds.forEach((key, controller) {
                final value = double.tryParse(controller.text) ?? 0.0;
                historyService.setColorThreshold(key, value);
              });

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeService.primaryColor,
              foregroundColor: Colors.black,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdField(
    String label,
    Color color,
    TextEditingController controller,
    ThemeService themeService,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor.withOpacity(0.7),
                  fontSize: 12,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
