import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'screens/start_page.dart';
import 'screens/login_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/list_page.dart';
import 'screens/list_collection.dart';
import 'screens/reminder_collection.dart';
import 'screens/filler_page.dart';
import 'services/notif_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  tz.initializeTimeZones();
  
  // Get the local timezone and set it for the timezone package
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

  await NotifService.instance.init();

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
        '/startpage': (context) => const StartPage(),
        '/homepage': (context) => const HomePage(userId: ' ',),
        '/profilepage': (context) => const ProfilePage(),
        '/loginpage': (context) => const LogInPage(),
        '/signuppage': (context) => const SignUpPage(),
        '/listcollection': (context) => ListCollectionPage(),
        '/listpage': (context) => ListPage(listID: ' ',),
        '/remindercollection': (context) => ReminderCollectionPage(),
        '/wip': (context) => const FillerPage(userId: ' ',),
      },
      
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, _, _) {
            switch (settings.name) {
              case '/homepage':
                final userId = settings.arguments as String;
                return HomePage(userId: userId);
              case '/listpage':
                final listId = settings.arguments as String;
                return ListPage(listID: listId);
              case '/listcollection':
                return ListCollectionPage();
              case '/profilepage':
                return const ProfilePage();
              case '/wip':
                final userId = settings.arguments as String;
                return FillerPage(userId: userId);
              default:
                return const StartPage();
            }
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      //Authentication for User Login
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
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