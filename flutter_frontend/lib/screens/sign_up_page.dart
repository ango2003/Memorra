import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_frontend/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  // Password validation: uppercase, number, special character
  bool isValidPassword(String password) {
    final uppercase = RegExp(r'[A-Z]');
    final number = RegExp(r'\d');
    final special = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    return password.length >= 8 &&
        uppercase.hasMatch(password) &&
        number.hasMatch(password) &&
        special.hasMatch(password);
  }

  // Signup function
  Future<void> createAccount() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Pre-check password
    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password must be at least 8 characters and include an uppercase letter, a number, and a special character.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create Auth user
      final userCredential = await _authService.createAccount(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        // Save user in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': Timestamp.now(),
          'provider': 'email',
        });

        if(!mounted) return;
        Navigator.pushReplacementNamed(context, '/homepage');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors (password rules, email taken, etc.)
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error creating account')),
      );
    } catch (e) {
      // Handle any other errors
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: Text("Email Address")
                ),
              ),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  label: Text("Password")
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/homepage');
                }, 
                child: Text("Sign Up")
              )
            ],
          )
        ),
      ),
    );
  }
}