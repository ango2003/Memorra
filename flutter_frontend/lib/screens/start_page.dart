import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final sizebox_size = height * 0.05;
    final fontsize_title = width * 0.1;
    final fontsize_button = width * 0.05;

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
                
                SizedBox(height: sizebox_size * 2), // Extra space at the top

                //Welcome Text
                Text(
                  "Welcome to\nMemorra",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontsize_title,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Color(0xFF071F4A),
                  ),
                ),

                SizedBox(height: sizebox_size),

                //Sign Up Button
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
                    style: TextStyle(fontSize: fontsize_button),
                  ),
                ),

                SizedBox(height: sizebox_size / 2),

                //Log In Button
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
                    style: TextStyle(fontSize: fontsize_button),
                  ),
                ),
              ],
            ),

            //Centered app logo
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Image.asset(
                    'assets/logo.png',
                    width: width * 0.5,
                    height: width * 0.5,
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