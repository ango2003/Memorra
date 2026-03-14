import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final fontsize_title = base * 0.12;
    final spacing_size = base * 0.03;
    final button_width = base * 0.75;
    final button_height = base * 0.15;
    final button_padding_horizontal = base * 0.05;
    final button_padding_vertical = base * 0.04;
    final fontsize_button = base * 0.06;
    final logo_size = base * 0.65;

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

        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: spacing_size * 5),

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

                          SizedBox(height: spacing_size * 3.5),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(button_width, button_height),
                              padding: EdgeInsets.symmetric(
                                horizontal: button_padding_horizontal, 
                                vertical: button_padding_vertical
                              ),
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

                          SizedBox(height: 20),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(button_width, button_height),
                              padding: EdgeInsets.symmetric(
                                horizontal: button_padding_horizontal, 
                                vertical: button_padding_vertical
                              ),
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

                          SizedBox(height: spacing_size * 5),

                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.asset(
                                'assets/logo.png',
                                width: logo_size,
                                height: logo_size,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: spacing_size * 2),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}