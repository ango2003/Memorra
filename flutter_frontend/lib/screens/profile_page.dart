import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/auth_service.dart';
<<<<<<< HEAD
=======
import 'package:flutter_frontend/screens/start_page.dart';
>>>>>>> origin/main

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// Class need Auth refinement
class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  
  // Sign Out Function
  Future<void> signOut() async {
    
    setState(() => _isLoading = true);

    try {
    
      if (!mounted) return;

      await _authService.signOut();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => StartPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: ${e.message}')),
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
      appBar: AppBar(title: Text("Profile Page")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/homepage');
                },
                child: Text("Go To Home"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/listcollection');
                },
                child: Text("Gift Lists"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: ()async {
                  await authService.value.signOut();
<<<<<<< HEAD
                  Navigator.pushReplacementNamed(context, '/loginpage');
=======
                  Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => StartPage()),
                  (Route<dynamic> route) => false,
                );
>>>>>>> origin/main
                },
                child: Text("Sign Out"),
              )
            ]
          ),
        ),
      ),
    );
  }
}