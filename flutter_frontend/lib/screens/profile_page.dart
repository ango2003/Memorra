import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/auth_service.dart';
import 'package:flutter_frontend/screens/start_page.dart';
import 'package:flutter_frontend/widgets/nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  
  // Sign Out Function
  Future<void> signOut() async {
    
    setState(() => _isLoading = true);

    try {
      await authService.value.signOut();
      
      if (!mounted) return;
      
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StartPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed')),
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
            children: [
              ElevatedButton(
                onPressed:() {
                  Navigator.pushNamed(context, '/listcollection');
                },
                child: Text("Friend's Lists"),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : () { signOut(); },
                child: _isLoading
                  ? CircularProgressIndicator()
                  : const Text("Sign Out"),
              )
            ]
          ),
        ),
      ),       
      bottomNavigationBar: NavBar(
        currentIndex: 4,
      ),
    );
  }
}