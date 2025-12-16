import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

/// Service untuk export dan import semua data aplikasi
class DataExportService {
  /// Export semua data ke JSON file
  static Future<String?> exportData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Kumpulkan semua data
      final Map<String, dynamic> allData = {
        'export_version': '1.0.0',
        'export_date': DateTime.now().toIso8601String(),

        // Theme Settings
        'theme': {
          'primary_color': prefs.getInt('primary_color'),
          'background_color': prefs.getInt('background_color'),
          'primary_font': prefs.getString('primary_font'),
          'secondary_font': prefs.getString('secondary_font'),
          'use_snackbar': prefs.getBool('use_snackbar'),
          'show_day': prefs.getBool('show_day'),
          'show_date': prefs.getBool('show_date'),
          'show_stopwatch': prefs.getBool('show_stopwatch'),
          'show_timer': prefs.getBool('show_timer'),
          'card_color': prefs.getInt('card_color'),
          'clock_font_size': prefs.getDouble('clock_font_size'),
          'second_font_size': prefs.getDouble('second_font_size'),
          'stopwatch_font_size': prefs.getDouble('stopwatch_font_size'),
          'timer_font_size': prefs.getDouble('timer_font_size'),
          'stopwatch_page_font_size': prefs.getDouble(
            'stopwatch_page_font_size',
          ),
          'timer_page_font_size': prefs.getDouble('timer_page_font_size'),
        },

        // Day Label Colors (Clock Page)
        'day_colors': {
          for (int i = 0; i < 7; i++) 'day_$i': prefs.getInt('day_color_$i'),
        },

        // Stopwatch Current State
        'stopwatch': {
          'start_time': prefs.getInt('stopwatch_start'),
          'accumulated': prefs.getInt('stopwatch_accumulated'),
          'is_running': prefs.getBool('stopwatch_running'),
        },

        // Timer Current State
        'timer': {
          'end_time': prefs.getInt('timer_end'),
          'remaining': prefs.getInt('timer_remaining'),
          'is_running': prefs.getBool('timer_running'),
          'initial': prefs.getInt('timer_initial'),
        },

        // Stopwatch History & Settings
        'stopwatch_history': {
          'history': prefs.getString('stopwatch_history'),
          'target_hours': prefs.getDouble('stopwatch_target_hours'),
          'color_thresholds': prefs.getString('stopwatch_color_thresholds'),
        },

        // Alarms
        'alarms': {'alarms_data': prefs.getString('alarms_data')},
      };

      // Convert to JSON
      final jsonString = JsonEncoder.withIndent('  ').convert(allData);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'za_time_backup_$timestamp.json';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(jsonString);

      return filePath;
    } catch (e) {
      debugPrint('Error exporting data: $e');
      return null;
    }
  }

  /// Import data dari JSON file
  static Future<bool> importData(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('File does not exist: $filePath');
        return false;
      }

      final jsonString = await file.readAsString();
      final Map<String, dynamic> allData = jsonDecode(jsonString);

      final prefs = await SharedPreferences.getInstance();

      // Import Theme Settings
      if (allData.containsKey('theme')) {
        final theme = allData['theme'] as Map<String, dynamic>;
        if (theme['primary_color'] != null) {
          await prefs.setInt('primary_color', theme['primary_color']);
        }
        if (theme['background_color'] != null) {
          await prefs.setInt('background_color', theme['background_color']);
        }
        if (theme['primary_font'] != null) {
          await prefs.setString('primary_font', theme['primary_font']);
        }
        if (theme['secondary_font'] != null) {
          await prefs.setString('secondary_font', theme['secondary_font']);
        }
        if (theme['use_snackbar'] != null) {
          await prefs.setBool('use_snackbar', theme['use_snackbar']);
        }
        if (theme['show_day'] != null) {
          await prefs.setBool('show_day', theme['show_day']);
        }
        if (theme['show_date'] != null) {
          await prefs.setBool('show_date', theme['show_date']);
        }
        if (theme['show_stopwatch'] != null) {
          await prefs.setBool('show_stopwatch', theme['show_stopwatch']);
        }
        if (theme['show_timer'] != null) {
          await prefs.setBool('show_timer', theme['show_timer']);
        }
        if (theme['card_color'] != null) {
          await prefs.setInt('card_color', theme['card_color']);
        }
        if (theme['clock_font_size'] != null) {
          await prefs.setDouble('clock_font_size', theme['clock_font_size']);
        }
        if (theme['second_font_size'] != null) {
          await prefs.setDouble('second_font_size', theme['second_font_size']);
        }
        if (theme['stopwatch_font_size'] != null) {
          await prefs.setDouble(
            'stopwatch_font_size',
            theme['stopwatch_font_size'],
          );
        }
        if (theme['timer_font_size'] != null) {
          await prefs.setDouble('timer_font_size', theme['timer_font_size']);
        }
        if (theme['stopwatch_page_font_size'] != null) {
          await prefs.setDouble(
            'stopwatch_page_font_size',
            theme['stopwatch_page_font_size'],
          );
        }
        if (theme['timer_page_font_size'] != null) {
          await prefs.setDouble(
            'timer_page_font_size',
            theme['timer_page_font_size'],
          );
        }
      }

      // Import Day Colors
      if (allData.containsKey('day_colors')) {
        final dayColors = allData['day_colors'] as Map<String, dynamic>;
        for (int i = 0; i < 7; i++) {
          final colorValue = dayColors['day_$i'];
          if (colorValue != null) {
            await prefs.setInt('day_color_$i', colorValue);
          }
        }
      }

      // Import Stopwatch State
      if (allData.containsKey('stopwatch')) {
        final stopwatch = allData['stopwatch'] as Map<String, dynamic>;
        if (stopwatch['start_time'] != null) {
          await prefs.setInt('stopwatch_start', stopwatch['start_time']);
        }
        if (stopwatch['accumulated'] != null) {
          await prefs.setInt('stopwatch_accumulated', stopwatch['accumulated']);
        }
        if (stopwatch['is_running'] != null) {
          await prefs.setBool('stopwatch_running', stopwatch['is_running']);
        }
      }

      // Import Timer State
      if (allData.containsKey('timer')) {
        final timer = allData['timer'] as Map<String, dynamic>;
        if (timer['end_time'] != null) {
          await prefs.setInt('timer_end', timer['end_time']);
        }
        if (timer['remaining'] != null) {
          await prefs.setInt('timer_remaining', timer['remaining']);
        }
        if (timer['is_running'] != null) {
          await prefs.setBool('timer_running', timer['is_running']);
        }
        if (timer['initial'] != null) {
          await prefs.setInt('timer_initial', timer['initial']);
        }
      }

      // Import Stopwatch History
      if (allData.containsKey('stopwatch_history')) {
        final history = allData['stopwatch_history'] as Map<String, dynamic>;
        if (history['history'] != null) {
          await prefs.setString('stopwatch_history', history['history']);
        }
        if (history['target_hours'] != null) {
          await prefs.setDouble(
            'stopwatch_target_hours',
            history['target_hours'],
          );
        }
        if (history['color_thresholds'] != null) {
          await prefs.setString(
            'stopwatch_color_thresholds',
            history['color_thresholds'],
          );
        }
      }

      // Import Alarms
      if (allData.containsKey('alarms')) {
        final alarms = allData['alarms'] as Map<String, dynamic>;
        if (alarms['alarms_data'] != null) {
          await prefs.setString('alarms_data', alarms['alarms_data']);
        }
      }

      return true;
    } catch (e) {
      debugPrint('Error importing data: $e');
      return false;
    }
  }

  /// Pick file untuk import
  static Future<String?> pickImportFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      }

      return null;
    } catch (e) {
      debugPrint('Error picking file: $e');
      return null;
    }
  }

  /// Share exported file
  static Future<void> shareFile(String filePath) async {
    // Implementation depends on share_plus package
    // For now, just log the path
    debugPrint('File exported to: $filePath');
  }
}
