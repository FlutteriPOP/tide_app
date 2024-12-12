import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/themes.dart';
import 'controller/network_service.dart';
import 'firebase_options.dart';
import 'screens/other/splash.dart';
import 'services/Notification/message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.init();
  Get.put(NetworkService());
  firebaseApi.foreground();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    firebaseApi.showNotification(message);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Track Tide',
      theme: customTheme,
      home: const SplashScreen(),
    );
  }
}
