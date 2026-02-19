import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark 
            ? [
                Color(0xFF0A6F85),
                Color(0xFF071F4A),
              ]
            : [
                Color(0xFF3F6BB5),
                Color(0xFF0A8C7A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome to\nMemorra", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Color(0xFF071F4A),
                )
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size (200, 60),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signuppage');
                },
                child: Text('Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
              
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size (200, 60),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/loginpage');
                },
                child: const Text('Log In',
                style: TextStyle(
                    fontSize: 20,
                  )
                ),
              ),

              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset(
                  'assets/logo.png',
                  width: 300,
                  height: 300,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
