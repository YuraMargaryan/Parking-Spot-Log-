class NotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDateTime;
  final DateTime createdAt;
  final bool isActive;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDateTime,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      scheduledDateTime: DateTime.parse(json['scheduledDateTime']),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? scheduledDateTime,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  String get formattedDateTime {
    return '${scheduledDateTime.day}.${scheduledDateTime.month}.${scheduledDateTime.year} в ${scheduledDateTime.hour.toString().padLeft(2, '0')}:${scheduledDateTime.minute.toString().padLeft(2, '0')}';
  }

  bool get isPast {
    return scheduledDateTime.isBefore(DateTime.now());
  }

  Duration get timeUntilNotification {
    return scheduledDateTime.difference(DateTime.now());
  }
}

