import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
<<<<<<< HEAD
=======
import 'package:timezone/timezone.dart' as tz;
>>>>>>> origin/main

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class NotifService {

  //singleton pattern
  NotifService._privateConstructor();
  static final NotifService instance = NotifService._privateConstructor();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine initialization settings
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initSettingsIOS,
    );
        
     // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

    final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

  }

<<<<<<< HEAD
  Future<void> scheduleWithTimer(
    int id,
    String title,
    String body,
    DateTime scheduledDate
    ) async {
    final delay = scheduledDate.difference(DateTime.now());

    Future.delayed(delay, () async {
      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: 'Reminder',
        body: 'This is your scheduled reminder.',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel', 
            'Reminder Notifications', 
            channelDescription: 'Notifications for reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
    );
  }

=======
  // Method to show a local notification
  // Future<void> scheduleNotification({ 
    
  //   required int id,
  //   required String title,
  //   required String body,
  //   required DateTime scheduledDate,
  // }) async {
  //   try {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id: id,
  //     title: title,
  //     body: body,
  //     scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
  //     notificationDetails: const NotificationDetails( 
  //       android: AndroidNotificationDetails(
  //         'reminder_channel', 
  //         'Reminder Notifications', 
  //         channelDescription: 'Notifications for reminders',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //       iOS: DarwinNotificationDetails(
  //         sound: 'default.wav',
  //         presentAlert: true,
  //         presentBadge: true,
  //         presentSound: true,
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     matchDateTimeComponents: null,

  //   ); 
  //   print("Notification scheduled successfully!");
  //   } catch (e) {
  //     print("Error scheduling notification: $e");
  //   }
  // }
  Future<void> scheduleNotification({ 
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
}) async {
  try {
    // Convert scheduledDate to TZDateTime
    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    // Notification details
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel', 
        'Reminder Notifications', 
        channelDescription: 'Notifications for reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // If scheduled time is now or in the past, show immediately
    if (scheduledDate.isBefore(DateTime.now().add(const Duration(seconds: 1)))) {
      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: 'foreground_notification',
      );
      print('Notification shown immediately (foreground).');
      return;
    }

    // Otherwise, schedule normally
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduled,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    ); 

    print("Notification scheduled successfully for $scheduledDate!");
  } catch (e) {
    print("Error scheduling notification: $e");
  }
}
  Future<void> printPendingNotification() async {
    final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    print("Pending Notifications: ${pending.length}");
  }
>>>>>>> origin/main
}