class AlarmModel {
  final String id;
  final int hour;
  final int minute;
  final bool isEnabled;
  final List<bool> repeatDays; // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
  final String label;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    this.isEnabled = true,
    List<bool>? repeatDays,
    this.label = '',
  }) : repeatDays = repeatDays ?? List.filled(7, false);

  String get timeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'isEnabled': isEnabled,
      'repeatDays': repeatDays,
      'label': label,
    };
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      isEnabled: json['isEnabled'] as bool? ?? true,
      repeatDays:
          (json['repeatDays'] as List?)?.cast<bool>() ?? List.filled(7, false),
      label: json['label'] as String? ?? '',
    );
  }

  AlarmModel copyWith({
    String? id,
    int? hour,
    int? minute,
    bool? isEnabled,
    List<bool>? repeatDays,
    String? label,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
      repeatDays: repeatDays ?? this.repeatDays,
      label: label ?? this.label,
    );
  }
}
