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

  factory Connection.fromFirestore(Map<String, dynamic> data, String id) {
    return Connection(
      id: id,
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      'createdAt': createdAt,
    };
  }
}