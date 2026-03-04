import 'package:flutter/material.dart';
import 'widgets/nav_bar.dart';

class FillerPage extends StatelessWidget {
  final String userId;
  const FillerPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Work In Progress")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This page is currently just a filler page.\nThe final page is still a work in progress.\nThank you for your patience.'),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: -1,
      ),
    );
  }
}