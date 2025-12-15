import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Service untuk pre-load Google Fonts agar tersedia offline
class GoogleFontsService {
  static bool _isPreloaded = false;

  /// Check if fonts are already preloaded
  static bool get isPreloaded => _isPreloaded;

  /// Download dan cache semua fonts yang digunakan dalam aplikasi
  /// Panggil ini saat aplikasi pertama kali dibuka
  /// Returns true if successful, false if error (but app can still run)
  static Future<bool> preloadFonts() async {
    if (_isPreloaded) return true;

    try {
      print('📥 Starting Google Fonts download...');
      // Pre-load semua font yang digunakan
      await Future.wait([
        // Orbitron
        GoogleFonts.pendingFonts([
          GoogleFonts.orbitron(),
          GoogleFonts.orbitron(fontWeight: FontWeight.bold),
        ]),
        // PT Sans
        GoogleFonts.pendingFonts([
          GoogleFonts.ptSans(),
          GoogleFonts.ptSans(fontWeight: FontWeight.bold),
        ]),
        // Roboto
        GoogleFonts.pendingFonts([
          GoogleFonts.roboto(),
          GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ]),
        // Lato
        GoogleFonts.pendingFonts([
          GoogleFonts.lato(),
          GoogleFonts.lato(fontWeight: FontWeight.bold),
        ]),
        // Oswald
        GoogleFonts.pendingFonts([
          GoogleFonts.oswald(),
          GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ]),
        // Montserrat
        GoogleFonts.pendingFonts([
          GoogleFonts.montserrat(),
          GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ]),
        // Open Sans
        GoogleFonts.pendingFonts([
          GoogleFonts.openSans(),
          GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ]),
        // Poppins
        GoogleFonts.pendingFonts([
          GoogleFonts.poppins(),
          GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ]),
        // Anton
        GoogleFonts.pendingFonts([
          GoogleFonts.anton(),
          GoogleFonts.anton(fontWeight: FontWeight.bold),
        ]),
      ]);

      _isPreloaded = true;
      print('✓ All Google Fonts preloaded successfully');
      return true;
    } catch (e) {
      print('⚠ Error preloading Google Fonts: $e');
      print('⚠ App will continue using system fonts as fallback');
      // Font akan tetap bekerja, hanya akan download saat pertama kali digunakan
      _isPreloaded = true; // Mark as done to prevent retry
      return false;
    }
  }
}
