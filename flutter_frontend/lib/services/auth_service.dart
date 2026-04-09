import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<AppUser> createAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed.');
      }

      final fullName = '$firstName $lastName'.trim();
      final appUser = AppUser(id: user.uid, name: fullName, email: user.email);

      await firestore.collection('users').doc(user.uid).set({
        'name': fullName,
        'email': user.email,
        'firstName': firstName,
        'lastName': lastName,
        'createdAt': Timestamp.now(),
        'provider': 'email',
      }, SetOptions(merge: true));

      return appUser;
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

  Future<AppUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Login failed.');
      }

      return fetchUser(user.uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getLogInErrorMessage(e));
    }
  }

  Future<AppUser> fetchUser(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('User not found.');
    }
    return AppUser.fromFirestore(doc);
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

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw Exception('User is not signed in.');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    await user.delete();
    await firebaseAuth.signOut();
  }

  Future<void> changePassword({
    required String email,
    required String newPassword,
    required String currentPassword,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw Exception('User is not signed in.');
    }
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }
}
