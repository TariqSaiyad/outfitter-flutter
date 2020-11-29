// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    await tester.pumpWidget(MaterialApp(
        home: ItemsScreen(
      person: new Person(),
    )));

    // Verify that each of the category items are displayed.
    for (var type in TYPES) {
      expect(find.text(type['name'].toString().toUpperCase()), findsOneWidget);
    }
//    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();

    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
  });
}
