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

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // 🔹 Top content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                SizedBox(height: 200),

                Text(
                  "Welcome to\nMemorra",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Color(0xFF071F4A),
                  ),
                ),

                SizedBox(height: 100),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 60),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signuppage');
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 30),
                  ),
                ),

                SizedBox(height: 35),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 60),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginpage');
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),

            // 🔹 Centered app logo
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 350,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}