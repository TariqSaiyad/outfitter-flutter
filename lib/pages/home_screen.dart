import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/outfit.dart';
import 'package:Outfitter/pages/outfits_screen.dart';
import 'package:Outfitter/pages/search_screen.dart';
import 'package:Outfitter/pages/settings_screen.dart';
import 'package:Outfitter/widgets/item_tile.dart';
import 'package:camera/camera.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
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
  List<Item> items;
  List<Outfit> outfits;
  int currentPage = 1;
  PageController controller;
  Brightness brightness;

  /// True if the outfit page displaying the alt. view.
  bool isAltOutfitView = false;

  final BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.fullBanner,
    request: AdRequest(),
    listener: AdListener(),
  );

  InterstitialAd myInterstitial = InterstitialAd(
    // adUnitId: "ca-app-pub-6887785718682987/3507634048",
    adUnitId: InterstitialAd.testAdUnitId,
    listener: AdListener(
      onAdLoaded: (Ad ad) => print("LOADED"),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) => print('Left application.'),
    ),
    request: AdRequest(keywords: <String>[
      'clothing',
      'outfits',
      'jacket',
      'footwear',
      'shoes'
    ]),
  );

  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
  }

  @override
  void initState() {
    super.initState();

    items = Hive.box<Item>(HiveBoxes.items).values.toList();
    outfits = Hive.box<Outfit>(HiveBoxes.outfits).values.toList();

//    resetPref();
    //TODO: ad stuff
    // _showAd();
    controller = PageController(initialPage: currentPage);
    controller.addListener(
        () => setState(() => currentPage = controller.page.floor()));
    brightness = ThemeData.estimateBrightnessForColor(
        Color(PrefService.getInt('primary_col')));

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(context, FEATURES);
    });
  }

  void _showAd() async {
//    TODO: add random event.
//    Random rand = new Random();
//    if (rand.nextBool()) return;
    await myInterstitial.load();
    // myInterstitial.show();
    await myBanner.load();
  }

//  void resetPref(BuildContext context) {
//    FeatureDiscovery.hasPreviouslyCompleted(context, 'first_id')
//        .then((value) => print(value));
//    FeatureDiscovery.clearPreferences(context, ['first_id'])
//        .then((value) => print("RESET!!!!"));
//    FeatureDiscovery.discoverFeatures(context, ['first_id']);
//
//  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    var complement = Helper.getComplement(Theme.of(context).primaryColor);
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
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: currentPage == 2
                    ? IconButton(
                        tooltip: "Alternate View",
                        icon: Icon(!isAltOutfitView
                            ? Icons.swap_horiz
                            : Icons.swap_horizontal_circle),
                        onPressed: () => _toggleAltView())
                    : const SizedBox()),
            IconButton(
                tooltip: "Search Items",
                icon: const Icon(Icons.search),
                onPressed: () => _goToSearch(context)),
            IconButton(
                tooltip: "Settings Page",
                icon: const Icon(Icons.settings),
                onPressed: () => _goToSettings(context)),
//            IconButton(
//                tooltip: "Settings Page",
//                icon: const Icon(Icons.category),
//                onPressed:()=> resetPref(context))
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
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: <Widget>[
            AddItemScreen(cameras: widget.cameras, analytics: widget.analytics),
            ItemsScreen(banner: myBanner),
            OutfitScreen(isAltOutfitView: isAltOutfitView),
          ],
        ));
  }

  void _toggleAltView() {
    setState(() {
      isAltOutfitView = !isAltOutfitView;
    });
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
                builder: (context) => SearchScreen()))
        .then((value) => setScreen(SCREEN_MAP[currentPage]));
  }

  void _goToAddOutfit(BuildContext context) {
    setScreen("add_outfit_page");
    Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: 'add_outfit_page'),
                builder: (context) =>
                    AddOutfitScreen(analytics: widget.analytics)))
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
    this.banner,
  }) : super(key: key);

  final BannerAd banner;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      const SizedBox(height: 4),
      for (var i in TYPES)
        Expanded(
          child: ItemTile(
            type: i,
          ),
        ),
      //TODO: remove late to enable ad
      // Expanded(child: AdWidget(ad: banner)),
      const SizedBox(height: 4),
    ]));
  }
}
