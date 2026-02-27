import 'package:flutter/material.dart';
import 'widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome! Your UID is: $userId'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profilepage');
              },
              child: Text("Go To Profile"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/profilepage');
          }
          else if (index == 2) {
            Navigator.pushNamed(context, '/listpage');
          }
        },
      ),
    );
  }
}