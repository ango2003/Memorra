import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_links/app_links.dart';
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
  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  bool _handleInitialLink = false;

  Future<void> _initDeepLinkListener() async {
    try {
      final appLinks = AppLinks();
      final initialUrl = await appLinks.getInitialLink();

      if (!_handleInitialLink && initialUrl != null) {
        _handleInitialLink = true;
        DeepLinkService.instance.handleIncomingLink(initialUrl);
      }

      appLinks.uriLinkStream.listen((Uri url) {
        DeepLinkService.instance.handleIncomingLink(url);
      });
    } catch (e) {
      print('Error occurred while initializing deep link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorra',
      debugShowCheckedModeBanner: false,
      routes: {
        '/startpage': (context) => const StartPage(),
        '/homepage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final currentUser = FirebaseAuth.instance.currentUser;
          final userId = args is String ? args : currentUser?.uid ?? '';
          return HomePage(userId: userId);
        },
        '/profilepage': (context) => const ProfilePage(),
        '/loginpage': (context) => const LogInPage(),
        '/signuppage': (context) => const SignUpPage(),
        '/listcollection': (context) => ListCollectionPage(),
        '/listpage': (context) => ListPage(listID: ' '),
        '/remindercollection': (context) => ReminderCollectionPage(),
        '/connectionpage': (context) => ConnectionsPage(),
        '/requestpage': (context) => const ConnectionsRequestPage(),
        '/invitepage': (context) => const ConnectionsInvitePage(),
        '/wip': (context) => const FillerPage(userId: ' '),
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
