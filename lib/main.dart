import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Auth/login_screen.dart';
import 'Screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/splash_screen.dart';
import 'firebase_options.dart';

late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // For Full Screen at Splash Screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // For setting the orientation Up
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    _initializeFirebase();

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat Application',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 1,
            backgroundColor: Colors.white,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 19,
            ),
          ),
          primarySwatch: Colors.amber,
        ),
        home: SplashScreen());
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
