import 'package:flutter/material.dart';
import '../widgets/home_tile.dart';
import '../widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final sizebox_size = height * 0.05;
    final fontsize = width * 0.08;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: sizebox_size),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Text(
                  "How Can We Help $userId?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 75,
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
              SizedBox(height: sizebox_size),

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
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: sizebox_size),
                    Row(
                      children: [
                        Expanded(
                          child: HomeTile(
                            title: "Suggested Reminders",
                            onTap: () {
                              Navigator.pushNamed(context, '/wip');
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: HomeTile(
                            title: "Friend Gift Ideas",
                            onTap: () {
                              Navigator.pushNamed(context, '/wip');
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: sizebox_size),
                    Row(
                      children: [
                        Expanded(
                          child: HomeTile(
                            title: "Set New Reminder",
                            onTap: () {
                              Navigator.pushNamed(context, '/wip');
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: sizebox_size),
                  ],
                ),
              )
            ],
          )
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2,
      ),
    );
  }
}