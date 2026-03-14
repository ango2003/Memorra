class Reminder {
  final String id;
  final String name;
  final String category;

  Reminder({
    required this.id,
    required this.name,
    required this.category,
  });

  /// Convert Firestore → Gift object
  factory Reminder.fromFirestore(Map<String, dynamic> data, String id) {
    return Reminder(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
    );
  }

  /// Convert Reminder → Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
    };
  }
}