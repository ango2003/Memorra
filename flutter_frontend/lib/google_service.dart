//760425569432-fjc2blcp2phd4pp5i5uvb7u5qmhutqlb.apps.googleusercontent.com

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign in with Google (cross-platform)
  Future<User?> signInWithGoogle() async {
    try {
      // Web & Desktop → Firebase popup handles OAuth
      final userCredential = await _firebaseAuth.signInWithPopup(GoogleAuthProvider());

      // Save to Firestore
      await _saveUserToFirestore(userCredential.user!);
      return userCredential.user;
    } on FirebaseAuthException catch (_) {
      rethrow; // Keep Firebase exceptions separate
    } catch (e) {
      // Wrap any other errors in GoogleSignInException
      throw GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: e.toString(),
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      throw GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: e.toString(),
      );
    }
  }

  /// Save user info to Firestore
  Future<void> _saveUserToFirestore(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
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