class Reminder {
  final String id;
  final String name;
  final String category;

  Reminder({required this.id, required this.name, required this.category});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
    );
  }

  /// Convert Firestore → Reminder object
  factory Reminder.fromFirestore(Map<String, dynamic> data, String id) {
    return Reminder(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'category': category};
  }

  /// Convert Reminder → Firestore map
  Map<String, dynamic> toFirestore() {
    return {'name': name, 'category': category};
  }
}
