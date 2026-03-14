import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();

      UserCredential userCredential;

      if (kIsWeb) {
        // Web
        userCredential =
            await _firebaseAuth.signInWithPopup(provider);
      } else {
        // Android & iOS
        userCredential =
            await _firebaseAuth.signInWithProvider(provider);
      }

      await _saveUserToFirestore(userCredential.user!);
      return userCredential.user;

    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> _saveUserToFirestore(User user) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDoc.set(
      {
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'lastLogin': FieldValue.serverTimestamp(),
        'loginMethod': 'google',
      },
      SetOptions(merge: true),
    );
  }
}