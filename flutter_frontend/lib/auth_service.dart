import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed.');
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'createdAt': Timestamp.now(),
        'provider': 'email',
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e));
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    return switch (e.code) {
      'email-already-in-use' => 'An account already exists for that email.',
      'weak-password' => 'Password is too weak.',
      _ => e.message ?? 'Account creation failed.',
    };
  }

  Future<UserCredential> logIn( {
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Login failed.');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getLogInErrorMessage(e));
    }
  }

  String _getLogInErrorMessage(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' => 'No user found with that email.',
      'wrong-password' => 'Incorrect password.',
      _ => e.message ?? 'Login failed.',
    };
  }

  // Unfinished Code Blocks
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(
      email: email
    );
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> changePasswordFromCurrentPassword({
    required String email,
    required String newPassword,
    required String currentPassword,
  }) async {
    AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword); 
  }
}