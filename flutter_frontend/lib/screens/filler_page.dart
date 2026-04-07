import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';

class FillerPage extends StatelessWidget {
  final String userId;
  const FillerPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;
    final bodyFontSize = base * 0.045;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(""),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: sizeboxSize),

              Text(
                "Work In Progress",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              Divider(
                color: isDark ? Colors.white : Colors.black54,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),

              SizedBox(height: sizeboxSize),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This page is currently just a filler page.\n"
                  "The final page is still a work in progress.\n"
                  "Thank you for your patience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    color: titleColor,
                  ),
                ),
              ),

              SizedBox(height: sizeboxSize),
            ],
          ),
        ),

        bottomNavigationBar: const NavBar(
          currentIndex: -1,
        ),
      ),
    );
  }
}
