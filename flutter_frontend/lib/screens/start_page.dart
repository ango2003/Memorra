import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // shrink to fit content
          children: [
            // First button: navigate to Sign Up
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signuppage');
              },
              child: const Text('Sign Up'),
            ),
            
            const SizedBox(height: 16), // spacing between buttons
             ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginpage');
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
