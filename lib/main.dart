// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thebrandsapp/firebase_options.dart';
import 'package:thebrandsapp/providers/id_provider.dart';
import 'package:thebrandsapp/services/notifications_services.dart';

import 'auth/supplier_login.dart';
import 'auth/supplier_signup.dart';
import 'main_screens/onboarding_screen.dart';
import 'main_screens/supplier_home.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
  print("Handling a background message: ${message.notification!.body}");
  print("Handling a background message: ${message.data}");
  print("Handling a background message: ${message.data['key1']}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationsServices.createNotificationChannelAndInitialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => IdProvider()),
  ], child: const GetMaterialApp(home: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/supplier_home',
      routes: {
        '/onboarding_screen': (context) => const Onboardingscreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/supplier_signup': (context) => const SupplierRegister(),
        '/supplier_login': (context) => const SupplierLogin(),
      },
    );
  }
}
