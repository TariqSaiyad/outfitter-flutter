import 'package:Outfitter/config.dart';
import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:camera/camera.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/home_screen.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

List<CameraDescription> cameras;
FirebasePerformance _firebasePerformance;
FirebaseAnalytics _firebaseAnalytics;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  //Hive stuff
  await Hive.initFlutter();
  HiveHelpers.registerAdapters();
  await HiveHelpers.openBoxes();
  themeBox = await Hive.openBox('themeBox');

  // init firebase stuff
  await Firebase.initializeApp();
  print(_firebasePerformance.toString());
  cameras = await availableCameras();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  _firebaseAnalytics = FirebaseAnalytics();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    appTheme.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: MaterialApp(
        title: 'Outfitter',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: _firebaseAnalytics),
        ],
        theme: appTheme.themeData,
        themeMode: appTheme.currentTheme,
        routes: <String, WidgetBuilder>{
          'home_page': (BuildContext context) {
            return HomeScreen(
              cameras: cameras,
              analytics: _firebaseAnalytics,
            );
          }
        },
        initialRoute: 'home_page',
      ),
    );
  }
}
