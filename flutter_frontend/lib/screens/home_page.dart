import 'package:flutter/material.dart';
import '../widgets/home_tile.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';
import '../themes/app_colors.dart';

class HomePage extends StatelessWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final titleFontSize = base * 0.08;
    final fontSize = base * 0.08; // Currently not used, but can be applied to tile text if needed
    final horizontalSpacing = width * 0.02;
    final hPadding = width * 0.01;
    final wPadding = height * 0.01;

    Color titleColor = isDark ? AppColors.titleDark : AppColors.titleLight;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: sizeboxSize),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: wPadding),
                child: Text(
                  "How Can We Help $userId?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
              Divider(
               color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black54,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: sizeboxSize),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: HomeTile(
                            title: "Today's Reminders",
                            onTap: () {
                              Navigator.pushNamed(context, '/wip');
                            },
                            inMiddle: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizeboxSize),
                    Row(
                      children: [
                        Expanded(
                          child: HomeTile(
                            title: "Suggested Reminders",
                            onTap: () {
                              Navigator.pushNamed(context, '/wip');
                            },
                            inMiddle: true,
                          ),
                        ),
                        SizedBox(width: horizontalSpacing),
                        Expanded(
                          child: HomeTile(
                            title: "Friend Gift Ideas",
                            onTap: () {
                              Navigator.pushNamed(context, '/wip');
                            },
                            inMiddle: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizeboxSize),
                    Row(
                      children: [
                        Expanded(
                          child: HomeTile(
                            title: "Set New Reminder",
                            onTap: () {
                              Navigator.pushNamed(context, '/remindercollection');
                            },
                            inMiddle: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizeboxSize),
                  ],
                ),
              )
            ],
          )        
        ),
        bottomNavigationBar: NavBar(
          currentIndex: 2,
        ),
      ),
    );
  }
}