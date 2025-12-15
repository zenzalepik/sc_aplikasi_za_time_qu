import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../widgets/font_size_slider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                "Settings".toUpperCase(),
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Colors Section
              Text(
                "Colors",
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildColorSection(
                context,
                "Primary Color",
                themeService.primaryColor,
                (color) => themeService.setPrimaryColor(color),
                themeService,
              ),
              const SizedBox(height: 30),
              _buildColorSection(
                context,
                "Background Color",
                themeService.backgroundColor,
                (color) => themeService.setBackgroundColor(color),
                themeService,
              ),

              const SizedBox(height: 40),
              Divider(color: themeService.primaryColor.withValues(alpha: 0.3)),
              const SizedBox(height: 20),

              // Clock Card Section
              Text(
                "Clock Card",
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildColorSection(
                context,
                "Card Background Color",
                themeService.cardColor,
                (color) => themeService.setCardColor(color),
                themeService,
              ),

              const SizedBox(height: 40),
              Divider(color: themeService.primaryColor.withValues(alpha: 0.3)),
              const SizedBox(height: 20),

              // Fonts Section
              Text(
                "Fonts",
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildFontSection(
                context,
                "Clock Font (Primary)",
                themeService.primaryFont,
                (font) => themeService.setPrimaryFont(font),
                themeService,
              ),
              const SizedBox(height: 30),
              _buildFontSection(
                context,
                "UI Font (Secondary)",
                themeService.secondaryFont,
                (font) => themeService.setSecondaryFont(font),
                themeService,
              ),

              const SizedBox(height: 40),
              Divider(color: themeService.primaryColor.withValues(alpha: 0.3)),
              const SizedBox(height: 20),

              // Font Sizes Section
              Text(
                "Font Sizes",
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              FontSizeSlider(
                title: "Clock Numbers",
                currentSize: themeService.clockFontSize,
                min: 50.0,
                max: 300.0,
                onSizeChanged: (size) => themeService.setClockFontSize(size),
                themeService: themeService,
              ),
              const SizedBox(height: 20),
              FontSizeSlider(
                title: "Second Display",
                currentSize: themeService.secondFontSize,
                min: 10.0,
                max: 50.0,
                onSizeChanged: (size) => themeService.setSecondFontSize(size),
                themeService: themeService,
              ),
              const SizedBox(height: 20),
              FontSizeSlider(
                title: "Stopwatch Display",
                currentSize: themeService.stopwatchFontSize,
                min: 10.0,
                max: 60.0,
                onSizeChanged: (size) =>
                    themeService.setStopwatchFontSize(size),
                themeService: themeService,
              ),
              const SizedBox(height: 20),
              FontSizeSlider(
                title: "Timer Display",
                currentSize: themeService.timerFontSize,
                min: 20.0,
                max: 100.0,
                onSizeChanged: (size) => themeService.setTimerFontSize(size),
                themeService: themeService,
              ),
              const SizedBox(height: 20),
              FontSizeSlider(
                title: "Stopwatch Page Numbers",
                currentSize: themeService.stopwatchPageFontSize,
                min: 30.0,
                max: 150.0,
                onSizeChanged: (size) =>
                    themeService.setStopwatchPageFontSize(size),
                themeService: themeService,
              ),
              const SizedBox(height: 20),
              FontSizeSlider(
                title: "Timer Page Numbers",
                currentSize: themeService.timerPageFontSize,
                min: 30.0,
                max: 150.0,
                onSizeChanged: (size) =>
                    themeService.setTimerPageFontSize(size),
                themeService: themeService,
              ),

              const SizedBox(height: 40),
              Divider(color: themeService.primaryColor.withValues(alpha: 0.3)),
              const SizedBox(height: 20),

              // Notifications Section
              Text(
                "Notifications",
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildToggle(
                context,
                themeService,
                "Show Snackbar Notifications",
                themeService.useSnackbar,
                (value) => themeService.setUseSnackbar(value),
              ),

              const SizedBox(height: 40),
              Divider(color: themeService.primaryColor.withValues(alpha: 0.3)),
              const SizedBox(height: 20),

              // Display Section
              Text(
                "Display",
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildToggle(
                context,
                themeService,
                "Show Day Name",
                themeService.showDay,
                (value) => themeService.setShowDay(value),
              ),
              const SizedBox(height: 15),
              _buildToggle(
                context,
                themeService,
                "Show Date",
                themeService.showDate,
                (value) => themeService.setShowDate(value),
              ),
              const SizedBox(height: 15),
              _buildToggle(
                context,
                themeService,
                "Show Stopwatch (Clock Page)",
                themeService.showStopwatch,
                (value) => themeService.setShowStopwatch(value),
              ),
              const SizedBox(height: 15),
              _buildToggle(
                context,
                themeService,
                "Show Timer (Clock Page)",
                themeService.showTimer,
                (value) => themeService.setShowTimer(value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSection(
    BuildContext context,
    String title,
    Color currentColor,
    Function(Color) onColorChanged,
    ThemeService themeService,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: themeService.getSecondaryTextStyle(
            color: themeService.primaryColor,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showColorPicker(context, currentColor, onColorChanged),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeService.primaryColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSection(
    BuildContext context,
    String title,
    String currentFont,
    Function(String) onFontChanged,
    ThemeService themeService,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: themeService.getSecondaryTextStyle(
            color: themeService.primaryColor,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: themeService.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          child: DropdownButton<String>(
            value: currentFont,
            isExpanded: true,
            dropdownColor: Colors.transparent,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: themeService.primaryColor),
            items: ThemeService.availableFonts.keys.map((String fontName) {
              return DropdownMenuItem<String>(
                value: fontName,
                child: Text(
                  fontName,
                  style: ThemeService.availableFonts[fontName]!(
                    color: themeService.primaryColor,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onFontChanged(newValue);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(
    BuildContext context,
    ThemeService themeService,
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: themeService.getSecondaryTextStyle(
              color: themeService.primaryColor,
              fontSize: 18,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: themeService.primaryColor,
          inactiveTrackColor: themeService.primaryColor.withOpacity(0.3),
          inactiveThumbColor: themeService.primaryColor.withOpacity(0.5),
        ),
      ],
    );
  }

  void _showColorPicker(
    BuildContext context,
    Color currentColor,
    Function(Color) onColorChanged,
  ) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ColorPickerDialog(
          initialColor: currentColor,
          onColorChanged: onColorChanged,
          themeService: themeService,
        );
      },
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorChanged;
  final ThemeService themeService;

  const _ColorPickerDialog({
    required this.initialColor,
    required this.onColorChanged,
    required this.themeService,
  });

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      title: Text(
        'Pick a color',
        style: TextStyle(color: widget.themeService.primaryColor),
      ),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _currentColor,
          onColorChanged: (color) {
            setState(() {
              _currentColor = color;
            });
          },
          labelTypes: const [],
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Select'),
          onPressed: () {
            widget.onColorChanged(_currentColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
