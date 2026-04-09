import 'package:cloud_firestore/cloud_firestore.dart';

class Connection {
  final String id;
  final List<String> participants;
  final DateTime createdAt;

  Connection({
    required this.id,
    required this.participants,
    required this.createdAt,
  });

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return DateTime.now();
  }

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      id: json['id'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  factory Connection.fromFirestore(Map<String, dynamic> data, String id) {
    return Connection(
      id: id,
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: _parseDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {'participants': participants, 'createdAt': createdAt};
  }
}
