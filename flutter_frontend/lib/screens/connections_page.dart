import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsTestPageState();
}

class _ConnectionsTestPageState extends State<ConnectionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connections Test")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/requestpage');
            }, 
            child: const Text("Go to Connection Requests")),
            
            const Divider(),
            
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/invitepage');
            }, 
            child: const Text("Go to Connection Invites"))
          ]
        ),
      ),
      bottomNavigationBar: NavBar(
          currentIndex: 3,
        ),
    );
  }
}