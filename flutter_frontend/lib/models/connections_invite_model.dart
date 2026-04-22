import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionInvite {
  final String inviterId;
  final String redeemBy;
  final String token;
  final bool isUsed;
  final DateTime createdAt;
  final DateTime expiresAt;

  ConnectionInvite({
    required this.inviterId,
    required this.redeemBy,
    required this.token,
    required this.isUsed,
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

  factory ConnectionInvite.fromJson(Map<String, dynamic> json) {
    return ConnectionInvite(
      inviterId: json['inviterId'] ?? '',
      redeemBy: json['redeemBy'] ?? '',
      token: json['token'] ?? '',
      isUsed: json['isUsed'] as bool? ?? false,
      createdAt: _parseDateTime(json['createdAt']),
      expiresAt: _parseDateTime(json['expiresAt']),
    );
  }

  factory ConnectionInvite.fromFirestore(Map<String, dynamic> data, String id) {
    return ConnectionInvite.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'inviterId': inviterId,
      'redeemBy': redeemBy,
      'token': token,
      'isUsed': isUsed,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      ...toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
    };
  }
}
