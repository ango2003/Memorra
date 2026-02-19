import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/auth_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  final AuthService _authService = AuthService();

  // Login Function
  Future<void> logIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.logIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';

      if (e.code == 'user-not-found') {
        message = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Center(
        child: SingleChildScrollView(
         padding: const EdgeInsets.all(24),
         child: Form(
           key: _formKey,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
                // EMAIL
                TextFormField(
                  controller: _emailController,
                 keyboardType: TextInputType.emailAddress,
                 decoration: const InputDecoration(
                   labelText: "Email Address",
                   border: OutlineInputBorder(),
                 ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return "Email is required";
                   }
                   return null;
                 },
               ),

               const SizedBox(height: 16),

                // PASSWORD
               TextFormField(
                 controller: _passwordController,
                 obscureText: _obscurePassword,
                 decoration: InputDecoration(
                   labelText: "Password",
                   border: const OutlineInputBorder(),
                   suffixIcon: IconButton(
                     icon: Icon(
                       _obscurePassword
                           ? Icons.visibility
                           : Icons.visibility_off,
                     ),
                     onPressed: () {
                       setState(() {
                         _obscurePassword = !_obscurePassword;
                       });
                     },
                   ),
                  ),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return "Password is required";
                   }
                   return null;
                 },
                ),

               const SizedBox(height: 24),

                _isLoading
                   ? const CircularProgressIndicator()
                   : SizedBox(
                       width: double.infinity,
                       child: ElevatedButton(
                         onPressed: _isLoading ? null : logIn,
                         child: const Text("Log In"),
                       ),
                     ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}