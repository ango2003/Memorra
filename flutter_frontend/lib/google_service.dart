import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  GoogleService() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        clientId: Platform.isWindows
            ? '760425569432-fjc2blcp2phd4pp5i5uvb7u5qmhutqlb.apps.googleusercontent.com'
            : null,
      );
    } catch (e) {
      print('GoogleSignIn initialization error: $e');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Interactive sign‑in
      final account = await _googleSignIn.authenticate(
        scopeHint: ['profile', 'email'],
      );

      // ID token only
      final auth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        // no accessToken here
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      await _saveUserToFirestore(userCredential.user!);
      return userCredential.user;
    } catch (e) {
      print('Google sign‑in failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

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