// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:Outfitter/config.dart';
import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/pages/home_screen.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'test_helper.dart';

void main() {
  setUpAll(() async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });

    const MethodChannel('vibration')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'hasVibrator') {
        return false;
      }
      return null;
    });

    await Hive.initFlutter();
    HiveHelpers.registerAdapters();
    themeBox = await Hive.openBox('themeBox');
    WidgetsFlutterBinding.ensureInitialized();
  });

  group("Homepage", () {
    testWidgets('displays all category tiles', (WidgetTester tester) async {
      await enterHomePage(tester);

      for (var type in TYPES) {
        expect(find.text(type['name'].toUpperCase()), findsOneWidget);
      }
      expect(find.text('-1'), findsNWidgets(TYPES.length));
    });

    testWidgets('displays App title', (WidgetTester tester) async {
      await enterHomePage(tester);

      expect(find.text('OUTFITTER'), findsOneWidget);
    });

    testWidgets('displays top bar icons', (WidgetTester tester) async {
      await enterHomePage(tester);

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('displays bottom bar text and icons',
        (WidgetTester tester) async {
      await enterHomePage(tester);

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.style_outlined), findsOneWidget);
      expect(find.text("New"), findsOneWidget);
      expect(find.text("Outfits"), findsOneWidget);
      expect(find.text("Items"), findsNothing);
    });
  });

  group('Outfit Screen', () {
    testWidgets('displays no outfit text', (WidgetTester tester) async {
      await enterHomePage(tester);
      await goToOutfitsPage(tester);
      expect(find.text("NO OUTFITS"), findsOneWidget);
    });

    testWidgets('displays an outfit', (WidgetTester tester) async {
      await enterHomePage(tester);
      await tester.runAsync(() => HiveHelpers.openBoxes());

      // add a mock outfit
      var o = await tester.runAsync(() => TestHelper.generateOutfit());
      await goToOutfitsPage(tester);

      // check that outfit is present
      expect(find.text(o.name), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);

      await tester.runAsync(() => HiveHelpers.deleteAll());
    });

    testWidgets('deletes an outfit', (WidgetTester tester) async {
      // set up the hive models.
      await tester.runAsync(() => HiveHelpers.openBoxes());
      // add a mock outfit
      var o = await tester.runAsync(() => TestHelper.generateOutfit());

      await enterHomePage(tester);
      await tester.runAsync(() => goToOutfitsPage(tester));

      expect(find.text(o.name), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // delete the outfit
      await tapButton(tester, find.byIcon(Icons.delete));
      await tester.runAsync(() => tapButton(tester, find.text('DELETE')));
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.text(o.name), findsNothing);
      expect(find.byIcon(Icons.delete), findsNothing);

      await tester.runAsync(() => HiveHelpers.deleteAll());
    });
  });

  group('Item Screen', () {
    testWidgets('displays no items if empty', (WidgetTester tester) async {
      await enterHomePage(tester);
      await tester.runAsync(() => HiveHelpers.openBoxes());
      await goToItemPage(tester, Categories.ACCESSORIES);
      expect(find.text("NO ITEMS"), findsOneWidget);
      expect(find.text("0"), findsOneWidget);
    });

    testWidgets('displays present items', (WidgetTester tester) async {
      var cat = Categories.ACCESSORIES;
      await enterHomePage(tester);
      await tester.runAsync(() => HiveHelpers.openBoxes());

      var i = await tester.runAsync(() => TestHelper.generateItem(cat));

      await goToItemPage(tester, cat);
      expect(find.text("1"), findsOneWidget);
      expect(find.text(i.name), findsOneWidget);

      await tester.runAsync(() => HiveHelpers.deleteAll());
    });
  });

  group('Item Detail Screen', () {
    testWidgets('can delete item', (WidgetTester tester) async {
      var cat = Categories.ACCESSORIES;
      await enterHomePage(tester);
      await tester.runAsync(() => HiveHelpers.openBoxes());
      // create item
      var i = await tester.runAsync(() => TestHelper.generateItem(cat));
      // go to item category page
      await goToItemPage(tester, cat);
      // check item is there
      expect(find.text("1"), findsOneWidget);
      expect(find.text(i.name), findsOneWidget);
      // go to detail page.
      await tapButton(tester, find.text(i.name));
      // delete item.
      await tester.runAsync(() => tapButton(tester, find.byIcon(Icons.delete)));
      await tester.pump();
      // check nothing there.
      expect(find.text(i.name), findsNothing);

      await tester.runAsync(() => HiveHelpers.deleteAll());
    });
  });

  group('Settings Screen', () {
    testWidgets('displays all options', (WidgetTester tester) async {
      await enterHomePage(tester);
      await goToSettings(tester);
      expect(find.text('Customisation'), findsOneWidget);
      expect(find.text('Primary Colour'), findsOneWidget);
      expect(find.text('Accent Colour'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('ABOUT APP'), findsOneWidget);
    });

    testWidgets('displays all options', (WidgetTester tester) async {
      await enterHomePage(tester);
      await goToSettings(tester);
      await tapButton(tester, find.text('ABOUT APP'));
      expect(find.text('Outfitter'), findsOneWidget);
      await tapButton(tester, find.text('CLOSE'));
    });
  });

  group('Item Model', () {
    test('with valid attributes', () {
      var i = Item("/path", "itemName", "ItemType", "ItemDressCode",
          "ItemColor", "ItemCategory");
      expect(i.image, "/path");
      expect(i.color, "ItemColor");
      expect(i.name, "itemName");
      expect(i.dressCode, "ItemDressCode");
      expect(i.category, "ItemCategory");
      expect(i.type, "ItemType");
    });
  });

  group('Outfit Model', () {
    test('with valid attributes', () async {
      // set up the hive models.
      await HiveHelpers.openBoxes();

      var i1 = await TestHelper.generateItem(Categories.ACCESSORIES);
      var i2 = await TestHelper.generateItem(Categories.SHIRTS);
      var i3 = await TestHelper.generateItem(Categories.PANTS);
      var i4 = await TestHelper.generateItem(Categories.SHOES);

      var o = Outfit("oName", [i1], [i2], i3, i4);

      expect(o.name, 'oName');
      expect(o.accessories.length, 1);
      expect(o.layers.length, 1);
      expect(o.pants, isNotNull);
      expect(o.shoes, isNotNull);

      await HiveHelpers.deleteAll();
    });
  });
}

Future enterHomePage(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: FeatureDiscovery(
        child: HomeScreen(analytics: null),
      ),
    ),
  );
}

Future goToSettings(WidgetTester tester) async {
  await tapButton(tester, find.byIcon(Icons.settings));
  expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  expect(find.text('SETTINGS'), findsOneWidget);
  await tester.pumpAndSettle(Duration(milliseconds: 500));
}

Future goToItemPage(WidgetTester tester, String cat) async {
  await tapButton(tester, find.text(cat.toUpperCase()));
  expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  expect(find.text(cat.toUpperCase()), findsOneWidget);
  await tester.pumpAndSettle(Duration(milliseconds: 500));
}

Future goToOutfitsPage(WidgetTester tester) async {
  await tapButton(tester, find.text("Outfits"));
  expect(find.byIcon(Icons.style_outlined), findsOneWidget);
  expect(find.text("Add Outfit"), findsOneWidget);
  await tester.pumpAndSettle(Duration(milliseconds: 500));
}

Future<void> tapButton(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
