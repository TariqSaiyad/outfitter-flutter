import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'pages/home_screen.dart';
import 'pages/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
              ),
              themeMode: ThemeMode.dark,
              home: HomeScreen());
        }
        return LoadingScreen();
      },
    );
  }
}
