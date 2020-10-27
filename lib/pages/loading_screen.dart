import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme
          .of(context)
          .primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 30,),
            Text("LOADING...",style: TextStyle(letterSpacing: 2),)
          ],
        ),
      ),
    );
  }
}
