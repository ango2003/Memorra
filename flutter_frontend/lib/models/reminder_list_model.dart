import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderList {
  final String id;
  final String name;
  final DateTime reminderDate;
  final int notifID;
  final DateTime? createdAt;

  ReminderList({
    required this.id,
    required this.name,
    required this.reminderDate,
    required this.notifID,
    this.createdAt,
  });

  factory ReminderList.fromJson(Map<String, dynamic> json) {
    final dateValue = json['reminder_date'] ?? json['date'] ?? '';
    final reminderDate = dateValue is Timestamp
        ? dateValue.toDate()
        : dateValue is DateTime
        ? dateValue
        : DateTime.tryParse(dateValue?.toString() ?? '') ?? DateTime.now();

    return ReminderList(
      id: json['id'] ?? '',
      name: json['reminder_name'] ?? json['name'] ?? '',
      reminderDate: reminderDate,
      notifID: json['notif_ID'] ?? json['notifId'] ?? 0,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : null,
    );
  }

  factory ReminderList.fromFirestore(Map<String, dynamic> data, String id) {
    final reminderDate = data['reminder_date'] is Timestamp
        ? (data['reminder_date'] as Timestamp).toDate()
        : data['reminder_date'] is DateTime
        ? data['reminder_date'] as DateTime
        : DateTime.tryParse(data['reminder_date']?.toString() ?? '') ??
              DateTime.now();

    return ReminderList(
      id: id,
      name: data['reminder_name'] ?? '',
      reminderDate: reminderDate,
      notifID: data['notif_ID'] ?? data['notifId'] ?? 0,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : data['createdAt'] is DateTime
          ? data['createdAt'] as DateTime
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reminder_name': name,
      'reminder_date': reminderDate.toIso8601String(),
      'notif_ID': notifID,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reminder_name': name,
      'reminder_date': Timestamp.fromDate(reminderDate),
      'notif_ID': notifID,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
