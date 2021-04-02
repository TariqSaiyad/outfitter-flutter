import 'package:Outfitter/constants/styles.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 30),
            const Text("LOADING...",
                style: Styles.spaced2, textDirection: TextDirection.ltr)
          ],
        ),
      ),
    );
  }
}
