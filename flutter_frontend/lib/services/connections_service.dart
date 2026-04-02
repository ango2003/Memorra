import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/connections_model.dart';
import '../models/connections_request_model.dart';
import '../models/connections_invite_model.dart';
import '../utils/token_generator.dart';

class ConnectionsService {
  ConnectionsService.privateConstructor();
  static final ConnectionsService instance = ConnectionsService.privateConstructor();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get userId {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  /// -------------------- INVITES --------------------
  Future<String> createInvite(Duration time) async {
    String token;

    while (true) {
      token = TokenGenerator.generateToken(10);
      final inviteRef = firestore.collection('connection_invites').doc(token);

      final success = await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(inviteRef);
        if (doc.exists) return false;

        final invite = ConnectionInvite(
          token: token,
          inviterId: userId,
          redeemBy: null, // null until someone redeems
          isUsed: false,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(time),
        );

        transaction.set(inviteRef, invite.toFirestore());
        return true;
      });

      if (success) break; // Successfully created
    }

    return token;
  }

  Future<bool> redeemInvite(String token) async {
    try {
      await firestore.runTransaction((transaction) async {
        final inviteRef = firestore.collection('connection_invites').doc(token);
        final inviteDoc = await transaction.get(inviteRef);
        if (!inviteDoc.exists) throw Exception('Invite not found');

        final invite = ConnectionInvite.fromFirestore(inviteDoc.data()!, inviteDoc.id);

        if (invite.isUsed ||
            invite.expiresAt.isBefore(DateTime.now()) ||
            invite.inviterId == userId) {
          throw Exception('Invalid or expired invite');
        }

        final connectionId = _generateConnectionId(invite.inviterId, userId);
        final connectionRef = firestore.collection('connections').doc(connectionId);

        // Check if connection already exists
        final connectionDoc = await transaction.get(connectionRef);
        if (connectionDoc.exists) throw Exception('Already connected');

        // Mark invite as used
        transaction.update(inviteRef, {
          'isUsed': true,
          'redeemBy': userId,
        });

        // Create connection
        transaction.set(connectionRef, {
          'participants': [invite.inviterId, userId],
          'users': {
            invite.inviterId: true,
            userId: true,
          },
          'redeemedBy': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      print('Error redeeming invite: $e');
      return false;
    }

    return true;
  }

  /// -------------------- CONNECTION REQUESTS --------------------
  Future<bool> sendConnectionRequest(String receiverId) async {
    final senderId = userId;
    if (senderId == receiverId) return false;
    if (await isConnected(senderId, receiverId)) return false;

    // Check for existing pending requests
    final snapshot = await firestore
        .collection('connection_requests')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .where('status', isEqualTo: RequestStatus.pending.name)
        .get();
    if (snapshot.docs.isNotEmpty) return false;

    // Check for reverse pending requests
    final reverseSnapshot = await firestore
        .collection('connection_requests')
        .where('senderId', isEqualTo: receiverId)
        .where('receiverId', isEqualTo: senderId)
        .where('status', isEqualTo: RequestStatus.pending.name)
        .get();
    if (reverseSnapshot.docs.isNotEmpty) return false;

    final request = ConnectionRequest(
      requestId: '', // Firestore generates the ID
      senderId: senderId,
      receiverId: receiverId,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: 1)),
    );

    await firestore.collection('connection_requests').add(request.toFirestore());
    return true;
  }

  Future<bool> acceptConnectionRequest(String requestId) async {
    final requestRef = firestore.collection('connection_requests').doc(requestId);

    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(requestRef);
        if (!doc.exists) throw Exception('Request not found');

        final request = ConnectionRequest.fromFirestore(doc.data()!, doc.id);

        if (request.status != RequestStatus.pending) throw Exception('Request not pending');
        if (request.receiverId != userId) throw Exception('Not the receiver');
        if (request.expiresAt.isBefore(DateTime.now())) throw Exception('Request expired');

        final connectionId = _generateConnectionId(request.senderId, request.receiverId);
        final connectionRef = firestore.collection('connections').doc(connectionId);

        final connectionDoc = await transaction.get(connectionRef);
        if (connectionDoc.exists) throw Exception('Already connected');

        // Create connection
        transaction.set(connectionRef, {
          'participants': [request.senderId, request.receiverId],
          'users': {
            request.senderId: true,
            request.receiverId: true,
          },
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Mark request as accepted
        transaction.update(requestRef, {'status': RequestStatus.accepted.name});
      });
    } catch (e) {
      print('Error accepting request: $e');
      return false;
    }

    return true;
  }

  Future<bool> declineConnectionRequest(String requestId) async {
    final doc = await firestore.collection('connection_requests').doc(requestId).get();
    if (!doc.exists) return false;

    final request = ConnectionRequest.fromFirestore(doc.data()!, doc.id);
    if (request.status != RequestStatus.pending) return false;
    if (request.receiverId != userId) return false;

    await firestore
        .collection('connection_requests')
        .doc(requestId)
        .update({'status': RequestStatus.declined.name});

    return true;
  }

  Future<bool> cancelConnectionRequest(String requestId) async {
    final doc = await firestore.collection('connection_requests').doc(requestId).get();
    if (!doc.exists) return false;

    final request = ConnectionRequest.fromFirestore(doc.data()!, doc.id);
    if (request.status != RequestStatus.pending) return false;
    if (request.senderId != userId) return false;

    await firestore
        .collection('connection_requests')
        .doc(requestId)
        .update({'status': RequestStatus.cancelled.name});

    return true;
  }

  /// -------------------- CONNECTIONS --------------------
  Future<bool> removeConnection(String connectionId) async {
    final doc = await firestore.collection('connections').doc(connectionId).get();
    if (!doc.exists) return false;

    final connection = Connection.fromFirestore(doc.data()!, doc.id);
    if (!connection.participants.contains(userId)) return false;

    await firestore.collection('connections').doc(connectionId).delete();
    return true;
  }

  Future<bool> isConnected(String userId1, String userId2) async {
    final connectionId = _generateConnectionId(userId1, userId2);
    final doc = await firestore.collection('connections').doc(connectionId).get();
    return doc.exists;
  }

  Stream<List<Connection>> getUserConnections(String userId) {
    return firestore
        .collection('connections')
        .where('users.$userId', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Connection.fromFirestore(doc.data(), doc.id)).toList());
  }

  Future<List<ConnectionRequest>> getSentConnectionRequests(String userId) {
    return firestore
        .collection('connection_requests')
        .where('senderId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get()
        .then((snapshot) =>
            snapshot.docs.map((doc) => ConnectionRequest.fromFirestore(doc.data(), doc.id)).toList());
  }

  Future<List<ConnectionRequest>> getReceivedConnectionRequests(String userId) {
    return firestore
        .collection('connection_requests')
        .where('receiverId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get()
        .then((snapshot) =>
            snapshot.docs.map((doc) => ConnectionRequest.fromFirestore(doc.data(), doc.id)).toList());
  }
}

/// -------------------- HELPERS --------------------
String _generateConnectionId(String userId1, String userId2) {
  final connectionId = [userId1, userId2]..sort();
  return connectionId.join('_');
}