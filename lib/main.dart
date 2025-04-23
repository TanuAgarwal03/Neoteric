import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neoteric_flutter/firebase_api.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:neoteric_flutter/splashscreen/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase SDK

  //  await Firebase.initializeApp();
// await Firebase.initializeApp();

  // if (Platform.isIOS) {
  //   await Firebase.initializeApp(
  //       options: const FirebaseOptions(
  //           apiKey: "AIzaSyCcuEiPN3_t14Aqc1gwEEvzbDNNtibVhoE",
  //           appId: "1:132854006365:android:6917afa0463f74c62e03b4",
  //           messagingSenderId: "132854006365",
  //           projectId: "neoteric-242a5"));
  //           // apiKey: "AIzaSyCpYWboLurAv0RJ_aL2EVWdB7sAM-C3h9A",
  //           // appId: "1:188168302093:ios:f9c85727822d862ba16f44",
  //           // messagingSenderId: "188168302093",
  //           // projectId: "neotericapp-fea07"));
  // } else {
  //   await Firebase.initializeApp();
  // }

  // await FirebaseApi().initNotifications();

  // print("FCM_start======");
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // print("FCMToken $fcmToken");

  // fcm_token=fcmToken;

  // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //   debugPrint('message received');
  //   debugPrint(event.notification!.body);
  // });

  // Run your app
  runApp(const MyApp());
}

String? fcm_token = "";

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final FirebaseMessaging messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   debugPrint('message received');
    //   debugPrint(event.data.toString());
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // });
    // messaging.subscribeToTopic("fcm-notification");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'Neoteric ',
        theme: ThemeData(fontFamily: "Poppins", useMaterial3: false).copyWith(
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: const Color(0xffFF2E00)),
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
                textScaler: TextScaler.linear(1.0)),
            child: child!,
          ),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(fcmToken: fcm_token!),
      ),
    );
  }
}
