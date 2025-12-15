import 'package:flutter/material.dart';
import 'dart:math' as math;

class AlarmRingingScreen extends StatefulWidget {
  final String alarmTime;
  final String alarmLabel;
  final VoidCallback onStop;
  final VoidCallback onSnooze;

  const AlarmRingingScreen({
    super.key,
    required this.alarmTime,
    required this.alarmLabel,
    required this.onStop,
    required this.onSnooze,
  });

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Time Display
            Text(
              widget.alarmTime,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 80,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 16),

            // Label
            if (widget.alarmLabel.isNotEmpty)
              Text(
                widget.alarmLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 24),
              ),

            const SizedBox(height: 80),

            // Animated Icon
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale:
                          1.0 +
                          (math.sin(_controller.value * 2 * math.pi) * 0.15),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent.withOpacity(0.1),
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.alarm,
                          size: 100,
                          color: Colors.greenAccent,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 80),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  // Snooze Button
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onSnooze,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(color: Colors.white54, width: 2),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.snooze, color: Colors.white, size: 32),
                            SizedBox(height: 4),
                            Text(
                              'Snooze',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Stop Button
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onStop,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.stop, color: Colors.white, size: 32),
                            SizedBox(height: 4),
                            Text(
                              'Stop',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Info text
            const Text(
              'Alarm akan mati otomatis setelah 3 menit',
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
