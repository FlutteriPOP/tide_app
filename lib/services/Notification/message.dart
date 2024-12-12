import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    log('Requesting permission...');
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('Permission granted.');

      // Ensure APNS token is set before fetching the FCM token
      String? apnsToken = await messaging.getAPNSToken();
      log('APNS Token: $apnsToken');

      // Fetch the FCM token
      String? token = await messaging.getToken();
      log('FCM Token: $token');

      // Save the token to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('notificationToken', token ?? '');

      // Get the saved token (for verification)
      String? savedToken = prefs.getString('notificationToken');
      log('Saved Token: $savedToken');

      // Listen for token refreshes and update SharedPreferences
      messaging.onTokenRefresh.listen((newToken) async {
        log('Token Refreshed: $newToken');
        await prefs.setString('notificationToken', newToken);
      });
        } else {
      log('Permission denied.');
    }

    // Initialize local notifications plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    // Create an Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Use a constant string here
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    // Create the Android notification channel on Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Create Android notification details
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    // Create iOS notification details
    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );

    // Combine platform-specific details into a single NotificationDetails object
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
      payload: 'item x',
    );
  }

  void handleNotification(RemoteMessage message) {
    if (message.notification == null) return;
  }

  // Handle foreground notifications (Android)
  void foreground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Title: ${message.notification!.title}');
        log('Body: ${message.notification!.body}');
        // Display a local notification here if you need to
        showNotification(message);
      }
    });

    // Handle messages opened from the notification tray (Android/iOS)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Title: ${message.notification!.title}');
      log('Body: ${message.notification!.body}');
      // Handle the message here (e.g., navigate to a specific screen)
    });

    // Handle messages received in the background (Android/iOS)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler (Android/iOS)
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // You can display a notification or perform other actions here
    log("Handling a background message: ${message.messageId}");
  }
}
