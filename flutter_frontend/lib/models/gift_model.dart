class Gift {
  final String id;
  final String name;
  final String category;

  Gift({required this.id, required this.name, required this.category});

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
    );
  }

  /// Convert Firestore → Gift object
  factory Gift.fromFirestore(Map<String, dynamic> data, String id) {
    return Gift(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'category': category};
  }

  /// Convert Gift → Firestore map
  Map<String, dynamic> toFirestore() {
    return {'name': name, 'category': category};
  }
}
