import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/services/data_export_service.dart';
import '../../../../core/services/time_service.dart';
import '../../../../core/services/stopwatch_history_service.dart';
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

              // Import/Export Section
              Text(
                "Data Backup",
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildExportButton(context, themeService),
              const SizedBox(height: 15),
              _buildImportButton(context, themeService),

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

  Widget _buildExportButton(BuildContext context, ThemeService themeService) {
    return ElevatedButton.icon(
      onPressed: () => _handleExport(context, themeService),
      icon: Icon(Icons.upload_file, color: themeService.primaryColor),
      label: Text(
        'Export Data',
        style: themeService.getSecondaryTextStyle(
          color: themeService.primaryColor,
          fontSize: 18,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: themeService.primaryColor.withValues(alpha: 0.1),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: themeService.primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildImportButton(BuildContext context, ThemeService themeService) {
    return ElevatedButton.icon(
      onPressed: () => _handleImport(context, themeService),
      icon: Icon(Icons.download, color: themeService.primaryColor),
      label: Text(
        'Import Data',
        style: themeService.getSecondaryTextStyle(
          color: themeService.primaryColor,
          fontSize: 18,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: themeService.primaryColor.withValues(alpha: 0.1),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: themeService.primaryColor, width: 2),
        ),
      ),
    );
  }

  Future<void> _handleExport(
    BuildContext context,
    ThemeService themeService,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: themeService.backgroundColor,
          content: Row(
            children: [
              CircularProgressIndicator(color: themeService.primaryColor),
              const SizedBox(width: 20),
              Text(
                'Exporting data...',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );

      // Export data
      final filePath = await DataExportService.exportData();

      if (!context.mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      if (filePath != null) {
        // Show success dialog with share option
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: themeService.backgroundColor,
            title: Text(
              'Export Successful',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your data has been exported successfully!',
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'File location:',
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeService.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    filePath,
                    style: themeService.getSecondaryTextStyle(
                      color: themeService.primaryColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await Share.shareXFiles([
                    XFile(filePath),
                  ], text: 'Za Time App Backup');
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeService.primaryColor,
                  foregroundColor: themeService.backgroundColor,
                ),
              ),
            ],
          ),
        );
      } else {
        // Show error dialog
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: themeService.backgroundColor,
            title: Text(
              'Export Failed',
              style: themeService.getSecondaryTextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Failed to export data. Please try again.',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      // Close loading if still open
      Navigator.pop(context);

      // Show error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: themeService.backgroundColor,
          title: Text(
            'Error',
            style: themeService.getSecondaryTextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'An error occurred: $e',
            style: themeService.getSecondaryTextStyle(
              color: themeService.primaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handleImport(
    BuildContext context,
    ThemeService themeService,
  ) async {
    try {
      // Pick file
      final filePath = await DataExportService.pickImportFile();

      if (filePath == null) {
        // User cancelled
        return;
      }

      if (!context.mounted) return;

      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: themeService.backgroundColor,
          title: Text(
            'Import Data?',
            style: themeService.getSecondaryTextStyle(
              color: themeService.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'This will replace all your current settings and data. Are you sure?',
            style: themeService.getSecondaryTextStyle(
              color: themeService.primaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeService.primaryColor,
                foregroundColor: themeService.backgroundColor,
              ),
              child: const Text('Import'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
      if (!context.mounted) return;

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: themeService.backgroundColor,
          content: Row(
            children: [
              CircularProgressIndicator(color: themeService.primaryColor),
              const SizedBox(width: 20),
              Text(
                'Importing data...',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );

      // Import data
      final success = await DataExportService.importData(filePath);

      if (!context.mounted) return;

      // Close loading
      Navigator.pop(context);

      if (success) {
        // Reload services
        await themeService.init();
        final timeService = Provider.of<TimeService>(context, listen: false);
        await timeService.init();
        final historyService = Provider.of<StopwatchHistoryService>(
          context,
          listen: false,
        );
        await historyService.init();

        if (!context.mounted) return;

        // Show success
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: themeService.backgroundColor,
            title: Text(
              'Import Successful',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Data imported successfully! The app will refresh.',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Force rebuild
                  (context as Element).markNeedsBuild();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeService.primaryColor,
                  foregroundColor: themeService.backgroundColor,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: themeService.backgroundColor,
            title: Text(
              'Import Failed',
              style: themeService.getSecondaryTextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Failed to import data. Please check the file and try again.',
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: themeService.backgroundColor,
          title: Text(
            'Error',
            style: themeService.getSecondaryTextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'An error occurred: $e',
            style: themeService.getSecondaryTextStyle(
              color: themeService.primaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
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
