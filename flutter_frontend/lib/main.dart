import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/start_page.dart';
import 'screens/login_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorra',
      debugShowCheckedModeBanner: false,
      routes: 
      {
        '/homepage': (context) => const HomePage(userId: '',),
        '/profilepage': (context) => const ProfilePage(),
        '/loginpage': (context) => const LoginPage(),
        '/signuppage': (context) => const SignUpPage(),
        '/listpage': (context) => const ListPage(),
      },
      //Authentication for User Login
      //The StreamBuilder goes here as the "home" of your app
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(body: Center(child: Text('Something went wrong')));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: Text("Loading..."))
            );
          }
          
          final user = snapshot.data;
          if (user != null) {
            return HomePage(userId: user.uid);
          }
          return const StartPage();
        },
      )
    );
  }
}


    