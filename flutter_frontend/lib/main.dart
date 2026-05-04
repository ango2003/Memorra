import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_frontend/screens/scan_qr_page.dart';
import 'firebase_options.dart';
import 'screens/start_page.dart';
import 'screens/login_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/giftlist_page.dart';
import 'screens/giftlist_collection.dart';
import 'screens/reminder_collection.dart';
import 'screens/filler_page.dart';
import 'screens/connections_page.dart';
import 'screens/connections_request_page.dart';
import 'screens/connections_invite_page.dart';
import 'screens/connection_profile_page.dart';
import 'screens/calendar_page.dart';
import 'services/notif_service.dart';
import 'services/deep_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await NotifService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _handleInitialLink = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  Future<void> _initDeepLinkListener() async {
    try {
      final appLinks = AppLinks();
      final initialUrl = await appLinks.getInitialLink();

      if (!_handleInitialLink && initialUrl != null) {
        _handleInitialLink = true;
        final success = await DeepLinkService.instance.handleIncomingLink(initialUrl);
        if (success) {
          _navigatorKey.currentState?.pushNamed('/connectionpage');
        }
      }

      appLinks.uriLinkStream.listen((Uri url) async {
        final success = await DeepLinkService.instance.handleIncomingLink(url);
        if (!mounted) return;
        if (success) {
          _navigatorKey.currentState?.pushNamed('/connectionpage');
        } else {
          final context = _navigatorKey.currentContext;
          if (context != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid or expired invite link')),
            );
          }
        }
      });
    } catch (e) {
      throw Exception('Error occurred while initializing deep link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Memorra',
      debugShowCheckedModeBanner: false,
      routes: {
        '/startpage': (context) => const StartPage(),
        '/loginpage': (context) => const LogInPage(),
        '/signuppage': (context) => const SignUpPage(),
        '/remindercollection': (context) => ReminderCollectionPage(),
        '/connectionpage': (context) => ConnectionsPage(),
        '/connectionprofile': (context) => const ConnectionProfilePage(userId: ' '),
        '/requestpage': (context) => const ConnectionsRequestPage(),
        '/invitepage': (context) => const ConnectionsInvitePage(),
        '/scanpage': (context) => const ScanQrPage(),
        '/calendarpage': (context) => const CalendarPage(),
      },

        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, _, _) {
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
                  return const ProfilePage(userId: ' ');
                case '/connectionprofile':
                  return const ConnectionProfilePage(userId: ' ');
                case '/calendarpage':
                  return const CalendarPage();
                case '/wip':
                  return FillerPage(userId: ' ');
                case '/reminderpage':
                  return ReminderCollectionPage();
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
            return const Scaffold(
              body: Center(child: Text('Something went wrong')),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: Text("Loading...")));
          }

          final user = snapshot.data;
          if (user != null) {
            return HomePage(userId: user.uid);
          }
          return const StartPage();
        },
      ),
    );
  }
}