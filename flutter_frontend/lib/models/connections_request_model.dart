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

  factory ConnectionRequest.fromFirestore(Map<String, dynamic> data, String id) {
    return ConnectionRequest(
      requestId: id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: RequestStatus.values.firstWhere((v) => v.name == data['status'], orElse: () => RequestStatus.pending),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
    );
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

enum RequestStatus {
    pending,
    accepted,
    declined,
    cancelled,
    expired,
  }