import 'package:flutter/material.dart';
import '../widgets/home_tile.dart';
import '../widgets/nav_bar.dart';
import '../widgets/background.dart';

class HomePage extends StatelessWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final base = width < height ? width : height;

    final sizeboxSize = base * 0.05;
    final fontSize = base * 0.08;
    final horizontalSpacing = width * 0.02;

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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Text(
                  "How Can We Help $userId?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Color(0xFF071F4A),
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