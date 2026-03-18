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

   factory ConnectionInvite.fromFirestore(Map<String, dynamic> data, String id) {
    return ConnectionInvite(
      inviterId: data['inviterId'] ?? '',
      redeemBy: data['redeemBy'] ?? '',
      token: data['token'] ?? '',
      isUsed: data['isUsed'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
     );
   }

   Map<String, dynamic> toFirestore() {
    return {
      'inviterId': inviterId,
      'redeemBy': redeemBy,
      'token': token,
      'isUsed': isUsed,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
   }
}