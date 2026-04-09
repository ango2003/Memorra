import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionRequest {
  final String requestId;
  final String senderId;
  final String receiverId;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;

  ConnectionRequest({
    required this.requestId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
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

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      requestId: json['requestId'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      status: RequestStatus.values.firstWhere(
        (v) => v.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
      createdAt: _parseDateTime(json['createdAt']),
      expiresAt: _parseDateTime(json['expiresAt']),
    );
  }

  factory ConnectionRequest.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    final request = ConnectionRequest.fromJson({'requestId': id, ...data});
    return request;
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status.name,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }
}

enum RequestStatus { pending, accepted, declined, cancelled, expired }
