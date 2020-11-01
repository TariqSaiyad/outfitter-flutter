import 'package:Outfitter/pages/outfits_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'pages/home_screen.dart';
import 'pages/loading_screen.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return LoadingScreen();
        }
        if (snapshot.connectionState == ConnectionState.done) {
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
            ),
          );
        }
        return LoadingScreen();
      },
    );
  }
}
