import 'package:camera/camera.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'pages/home_screen.dart';

//import 'pages/loading_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

List<CameraDescription> cameras;
FirebasePerformance _firebasePerformance;
FirebaseAnalytics _firebaseAnalytics;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print(_firebasePerformance.toString());
  cameras = await availableCameras();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await FirebaseAdMob.instance
      .initialize(appId: "ca-app-pub-6887785718682987~8592633287");

  _firebaseAnalytics = FirebaseAnalytics();

  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
//  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//final Future<bool> _initialization = Future.delayed(Duration(milliseconds: 100));
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Outfitter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.deepOrangeAccent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.pinkAccent,
      ),
      themeMode: ThemeMode.dark,
      home: HomeScreen(
        cameras: cameras,
        analytics: _firebaseAnalytics,
      ),
    );
//    return FutureBuilder(
//      future: _initialization,
//      builder: (context, snapshot) {
//        if (snapshot.hasError) {
//          return LoadingScreen();
//        }
//        if (snapshot.connectionState == ConnectionState.done) {
//          return new MaterialApp(
//            title: 'Outfitter',
//            debugShowCheckedModeBanner: false,
//            theme: ThemeData(
//              brightness: Brightness.light,
//              primaryColor: Colors.blue,
//              accentColor: Colors.deepOrangeAccent,
//            ),
//            darkTheme: ThemeData(
//              brightness: Brightness.dark,
//              primaryColor: Colors.deepPurple,
//              accentColor: Colors.pinkAccent,
//            ),
//            themeMode: ThemeMode.dark,
//            home: HomeScreen(
//              cameras: cameras,
//            ),
//          );
//        }
//        return LoadingScreen();
//      },
//    );
  }
}
