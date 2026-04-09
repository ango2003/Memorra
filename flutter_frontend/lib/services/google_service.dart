import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class GoogleService {
  GoogleService.privateConstructor();
  static final GoogleService instance = GoogleService.privateConstructor();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUser?> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();

      UserCredential userCredential;

      if (kIsWeb) {
        // Web
        userCredential = await _firebaseAuth.signInWithPopup(provider);
      } else {
        // Android & iOS
        userCredential = await _firebaseAuth.signInWithProvider(provider);
      }

      final user = userCredential.user;
      if (user == null) {
        return null;
      }

      await _saveUserToFirestore(user);
      return AppUser.fromFirebaseUser(user);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> _saveUserToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    await userDoc.set({
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'lastLogin': FieldValue.serverTimestamp(),
      'loginMethod': 'google',
    }, SetOptions(merge: true));
  }
}
