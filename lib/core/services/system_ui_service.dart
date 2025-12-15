import 'package:flutter/services.dart';

/// Service untuk manage system UI (status bar & navigation bar)
class SystemUIService {
  static SystemUiMode _currentMode = SystemUiMode.immersiveSticky;

  /// Toggle between immersive and normal mode
  static void toggleSystemUI() {
    if (_currentMode == SystemUiMode.immersiveSticky) {
      // Show system UI
      _currentMode = SystemUiMode.edgeToEdge;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      // Hide system UI
      _currentMode = SystemUiMode.immersiveSticky;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  /// Get current mode
  static SystemUiMode get currentMode => _currentMode;

  /// Check if system UI is hidden
  static bool get isHidden => _currentMode == SystemUiMode.immersiveSticky;
}
