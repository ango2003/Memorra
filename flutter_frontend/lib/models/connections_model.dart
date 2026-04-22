import 'package:cloud_firestore/cloud_firestore.dart';

class Connection {
  final String id;
  final Map<String, bool> userId;
  final List<String> participants;
  final DateTime createdAt;
  final String? redeemedBy;

  Connection({
    required this.id,
    required this.userId,
    required this.participants,
    required this.createdAt,
    this.redeemedBy,
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
      userId: Map<String, bool>.from(json['userId'] ?? {}),
      createdAt: _parseDateTime(json['createdAt']),
      redeemedBy: json['redeemedBy'] as String?,
    );
  }

  factory Connection.fromFirestore(Map<String, dynamic> data, String id) {
    return Connection(
      id: id,
      participants: List<String>.from(data['participants'] ?? []),
      userId: Map<String, bool>.from(data['userId'] ?? {}),
      createdAt: _parseDateTime(data['createdAt']),
      redeemedBy: data['redeemedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      if (redeemedBy != null) 'redeemedBy': redeemedBy,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      'userId': userId,
      'createdAt': createdAt,
      if (redeemedBy != null) 'redeemedBy': redeemedBy,
    };
  }
}
