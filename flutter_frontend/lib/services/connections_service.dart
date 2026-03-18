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

  String get userId => auth.currentUser!.uid;

  Future<String> createInvite(Duration time) async {
    String token;
    DocumentSnapshot tokenDoc;
    
    do {
      token = TokenGenerator.generateToken(10);
      tokenDoc = await firestore.collection('connection_invites').doc(token).get();
    } while (tokenDoc.exists);

    final invite = ConnectionInvite(
      token: token,
      inviterId: userId,
      redeemBy: userId,
      isUsed: false,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(time),
    );

    await firestore.collection('connection_invites').doc(token).set(invite.toFirestore());
    return token;
  }

  Future<bool> redeemInvite(String token) async {
    
    try {
      await firestore.runTransaction((transaction) async {
        final inviteRef = firestore.collection('connection_invites').doc(token);
        final doc = await transaction.get(inviteRef);
        if (!doc.exists) {
          throw Exception('Invite not found');
        }
  
        final invite = ConnectionInvite.fromFirestore(doc.data()!, doc.id);
  
        if (invite.isUsed || invite.expiresAt.isBefore(DateTime.now()) || invite.inviterId == userId) {
          throw Exception('Invalid or expired invite');
        }
        
        final connectionId = _generateConnectionId(invite.inviterId, userId);

        transaction.update(inviteRef, {'isUsed': true, 'redeemBy': userId});
  
        final connectionRef = firestore.collection('connections').doc(connectionId);
        transaction.set(connectionRef, {
         'participants': [invite.inviterId, userId],
         'users': {
            invite.inviterId: true,
            userId: true,
          },
         'redeemedBy': userId,
          'createdAt': DateTime.now(),
        });
     });
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> sendConnectionRequest(String receiverId) async {
    String senderId = userId;
    
    if (senderId == receiverId) return false;
    if (await isConnected(senderId, receiverId)) return false;

    final snapshot = await firestore
        .collection('connection_requests')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .where('status', isEqualTo: RequestStatus.pending.name)
        .get();
    
    if (snapshot.docs.isNotEmpty) return false;
    
    final request = ConnectionRequest(
      requestId: '', // Firestore will generate the ID
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
        if (!doc.exists) {
          throw Exception('Connection request not found');
        }
      
        final request = ConnectionRequest.fromFirestore(doc.data()!, doc.id);

        if (request.status != RequestStatus.pending) {
          throw Exception('Connection request is not pending');
        }
        if (request.expiresAt.isBefore(DateTime.now())) {
          throw Exception('Connection request has expired');
        }
        if (request.receiverId != userId) {
          throw Exception('You are not the receiver of this connection request');
        }

        final connectionId = _generateConnectionId(request.senderId, request.receiverId);
        final connectionsRef = firestore.collection('connections').doc(connectionId);

        transaction.set(connectionsRef, {
          'participants': [request.senderId, request.receiverId],
          'users': {
            request.senderId: true,
            request.receiverId: true,
          },
          'createdAt': DateTime.now(),
        });
        
        transaction.update(requestRef, {'status': RequestStatus.accepted.name});
      });
    } catch (e) {
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

    await firestore.collection('connection_requests').doc(requestId).update({'status': RequestStatus.declined.name});
    
    return true;
  }

  Future<bool> cancelConnectionRequest(String requestId) async {
    final doc = await firestore.collection('connection_requests').doc(requestId).get();
    if (!doc.exists) return false;

    final request = ConnectionRequest.fromFirestore(doc.data()!, doc.id);
    
    if (request.status != RequestStatus.pending) return false;
    if (request.senderId != userId) return false;
    
    await firestore.collection('connection_requests').doc(requestId).update({'status': RequestStatus.cancelled.name});
    
    return true;
  }

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
        .map((snapshot) => snapshot.docs
            .map((doc) => Connection.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<List<ConnectionRequest>> getSentConnectionRequests(String userId) {
      return firestore
        .collection('connection_requests')
        .where('senderId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => ConnectionRequest.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<List<ConnectionRequest>> getReceivedConnectionRequests(String userId) {
    return firestore
        .collection('connection_requests')
        .where('receiverId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => ConnectionRequest.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}

String _generateConnectionId(String userId1, String userId2) {
  final connectionId = [userId1, userId2]..sort();
  return connectionId.join('_');
}