import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sign_up_screen.dart';
import 'package:flutter_frontend/screens/log_in_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text('Sign Up'),
              ),
              
              const SizedBox(height: 16), // spacing between buttons

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogInScreen()),
                  );
                },
                child: const Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
