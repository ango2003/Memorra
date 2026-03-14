class Gift {
  final String id;
  final String name;
  final String category;

  Gift({
    required this.id,
    required this.name,
    required this.category,
  });

  /// Convert Firestore → Gift object
  factory Gift.fromFirestore(Map<String, dynamic> data, String id) {
    return Gift(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
    );
  }

  /// Convert Gift → Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
    };
  }
}