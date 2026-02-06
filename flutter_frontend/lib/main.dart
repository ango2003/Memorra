import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_frontend/screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialization of Database
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Simple Authentication detection
  FirebaseAuth.instance
  .userChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(
    MaterialApp(
      home: StartScreen(),
    ),
  );
}


    // Authentication for User Login
    // The StreamBuilder goes here as the "home" of your app
    //   home: StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
    //       if (snapshot.hasError) {
    //         return const Scaffold(body: Center(child: Text('Something went wrong')));
    //       }

    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Scaffold(body: Center(child: Text("Loading...")));
    //       }

    //       // If there is no user data, show the Sign In screen
    //       if (!snapshot.hasData) {
    //         //No screens yet
    //         //return const SignInScreen();
    //       }

    //       // If there is a user, show the Home screen
    //       final user = snapshot.data!;
    //       //No screens yet
    //       //return HomeScreen(userId: user.uid);
    //     },
    //   )