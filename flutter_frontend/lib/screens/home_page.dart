import 'package:flutter/material.dart';
import 'widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

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
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2
      ),
    );
  }
}