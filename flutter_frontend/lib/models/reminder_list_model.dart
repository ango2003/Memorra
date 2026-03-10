class ReminderList {
  final String id;
  final String recipient;

  ReminderList({
    required this.id,
    required this.recipient,
  });

  factory ReminderList.fromFirestore(Map<String, dynamic> data, String id) {
    return ReminderList(
      id: id,
      recipient: data['reminder_recipient'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reminder_recipient': recipient,
    };
  }
}