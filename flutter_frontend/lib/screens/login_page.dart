import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: Text("Email Address")
                ),
              ),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  label: Text("Password")
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/homepage');
                }, 
                child: Text("Login")
              )
            ],
          )
        ),
      ),
    );
  }
}