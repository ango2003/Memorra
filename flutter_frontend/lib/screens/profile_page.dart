import 'package:flutter/material.dart';
import 'widgets/nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/homepage');
                },
                child: Text("Go To Home"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/listpage');
                },
                child: Text("Gift List"),
              ),
            ]
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/homepage');
          }
          else if (index == 2) {
            Navigator.pushNamed(context, '/listpage');
          }
        },
      ),
    );
  }
}