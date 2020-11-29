import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/pages/outfits_screen.dart';
import 'package:Outfitter/pages/search_screen.dart';
import 'package:Outfitter/pages/settings_screen.dart';
import 'package:Outfitter/widgets/item_tile.dart';
import 'package:camera/camera.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preference_service.dart';

import '../constants/constants.dart';
import 'add_item_screen.dart';
import 'add_outfit_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FirebaseAnalytics analytics;

  const HomeScreen({Key key, this.cameras, this.analytics}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Person person;
  int currentPage = 1;
  PageController controller;
  Brightness brightness;

//Add the following code inside the State of the StatefulWidget
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['clothing', 'outfits', 'jacket', 'footwear', 'shoes'],
    childDirected: false,
    testDevices: <String>[],
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: "ca-app-pub-6887785718682987/3507634048",
//  adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
  }

  @override
  void initState() {
    super.initState();

    _showAd();
    controller = PageController(initialPage: currentPage);
    controller.addListener(
        () => setState(() => currentPage = controller.page.floor()));

    // set init screen as homepage.
    setScreen(SCREEN_MAP[1]);
    brightness = ThemeData.estimateBrightnessForColor(
        Color(PrefService.getInt('primary_col')));
  }

  void _showAd() async {
//    TODO: add random event.
//    Random rand = new Random();
//    if (rand.nextBool()) return;
    await myInterstitial.load();
    myInterstitial.show();
  }

  Future<bool> initData() {
    return Person.storage.ready.then((value) {
      if (person == null) {
        person = Person.fromStorage();
        print("HERE");
      }
//      print(person.toJson());
//      person.items.map((e) => print(e.name));
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Color complement = Helper.getComplement(Theme.of(context).primaryColor);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: _getFAB(context),
//      resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: currentPage == 0 ? 0 : null,
          title: const Text(
            "OUTFITTER",
            style:
                const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w400),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _goToSearch(context)),
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _goToSettings(context))
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
            activeColor: complement,
            color: complement,
            style: TabStyle.reactCircle,
            elevation: 3,
            top: currentPage == 0 ? 0 : -20,
            initialActiveIndex: 1,
            items: [
              TabItem(title: "New", icon: Icons.add),
              TabItem(title: "Items", icon: Icons.style_outlined),
              TabItem(title: "Outfits", icon: Icons.checkroom_rounded),
            ],
            onTap: (int i) => _goToPage(i)),
        body: FutureBuilder(
          future: initData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.hasData) {
              return PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: <Widget>[
                  AddItemScreen(
                    cameras: widget.cameras,
                    person: person,
                  ),
                  ItemsScreen(person: person),
                  OutfitScreen(person: person),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ));
  }

  FloatingActionButton _getFAB(BuildContext context) {
    return currentPage == 2
        ? FloatingActionButton.extended(
            heroTag: null,
            autofocus: true,
            highlightElevation: 0,
            splashColor: Theme.of(context).primaryColor,
            onPressed: () => _goToAddOutfit(context),
            label: Text("Add Outfit"),
          )
        : null;
  }

  void _goToPage(int i) {
    setScreen(SCREEN_MAP[i]);
    controller.animateToPage(i,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void _goToSettings(BuildContext context) {
    setScreen("settings_page");
    Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: 'settings_page'),
                builder: (context) => SettingsScreen(setScreen: setScreen)))
        .then((value) => setScreen(SCREEN_MAP[currentPage]));
  }

  void _goToSearch(BuildContext context) {
    setScreen("search_page");
    Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: 'search_page'),
                builder: (context) => SearchScreen(person: person)))
        .then((value) => setScreen(SCREEN_MAP[currentPage]));
  }

  void _goToAddOutfit(BuildContext context) {
    setScreen("add_outfit_page");
    Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: 'add_outfit_page'),
                builder: (context) => AddOutfitScreen(person: person)))
        .then((value) => setScreen(SCREEN_MAP[currentPage]));
  }

  void setScreen(String s) {
    print("Going to $s");
    widget.analytics
        ?.setCurrentScreen(screenName: s, screenClassOverride: s + "_class");
  }
}

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({
    Key key,
    @required this.person,
  }) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      const SizedBox(height: 4),
      for (var i in TYPES)
        Expanded(
          child: ItemTile(
            person: person,
            type: i,
          ),
        ),
      const SizedBox(height: 4),
    ]));
  }
}
