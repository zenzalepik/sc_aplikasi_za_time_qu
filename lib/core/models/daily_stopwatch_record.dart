/// Model untuk menyimpan data stopwatch harian
class DailyStopwatchRecord {
  final DateTime date;
  final Duration totalDuration;

  DailyStopwatchRecord({required this.date, required this.totalDuration});

  /// Get date string in format YYYY-MM-DD
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'date': dateKey, 'durationInSeconds': totalDuration.inSeconds};
  }

  /// Create from JSON
  factory DailyStopwatchRecord.fromJson(Map<String, dynamic> json) {
    final dateParts = (json['date'] as String).split('-');
    return DailyStopwatchRecord(
      date: DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      ),
      totalDuration: Duration(seconds: json['durationInSeconds']),
    );
  }

  /// Get hours as double (for display)
  double get totalHours => totalDuration.inSeconds / 3600;
}
