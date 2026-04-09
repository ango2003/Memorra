class ReminderList {
  final String id;
  final String recipient;

  ReminderList({required this.id, required this.recipient});

  factory ReminderList.fromJson(Map<String, dynamic> json) {
    return ReminderList(
      id: json['id'] ?? '',
      recipient: json['reminder_recipient'] ?? json['recipient'] ?? '',
    );
  }

  factory ReminderList.fromFirestore(Map<String, dynamic> data, String id) {
    return ReminderList(id: id, recipient: data['reminder_recipient'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'reminder_recipient': recipient};
  }

  Map<String, dynamic> toFirestore() {
    return {'reminder_recipient': recipient};
  }
}
