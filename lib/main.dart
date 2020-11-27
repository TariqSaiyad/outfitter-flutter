import 'package:camera/camera.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preferences.dart';

import 'pages/home_screen.dart';

//import 'pages/loading_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

List<CameraDescription> cameras;
FirebasePerformance _firebasePerformance;
FirebaseAnalytics _firebaseAnalytics;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init firebase stuff
  await Firebase.initializeApp();
  print(_firebasePerformance.toString());
  cameras = await availableCameras();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await FirebaseAdMob.instance
      .initialize(appId: "ca-app-pub-6887785718682987~8592633287");

  _firebaseAnalytics = FirebaseAnalytics();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({
    'primary_col': Colors.deepPurple.value,
    'accent_col': Colors.pinkAccent.value,
    'app_theme_bool': true
  });
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
//  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//final Future<bool> _initialization = Future.delayed(Duration(milliseconds: 100));
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: PrefService.getBool("app_theme_bool")
          ? Brightness.dark
          : Brightness.light,
      data: (brightness) => ThemeData(
        brightness: brightness,
        primaryColor: Color(PrefService.getInt('primary_col')),
        accentColor: Color(PrefService.getInt('accent_col')),
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
            title: 'Outfitter',
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: _firebaseAnalytics),
            ],
            theme: theme,
            themeMode: PrefService.getBool("app_theme_bool")
                ? ThemeMode.dark
                : ThemeMode.light,
            home: HomeScreen(
              cameras: cameras,
              analytics: _firebaseAnalytics,
            ));
      },
    );
  }
}
