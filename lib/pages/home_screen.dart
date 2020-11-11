import 'package:Outfitter/constants/constants.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/pages/outfits_screen.dart';
import 'package:Outfitter/pages/search_screen.dart';
import 'package:Outfitter/widgets/item_tile.dart';
import 'package:camera/camera.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'add_item_screen.dart';
import 'add_outfit_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({Key key, this.cameras}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Person person;
  int currentPage = 1;
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentPage);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page.floor();
      });
    });
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
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: currentPage == 2
            ? FloatingActionButton.extended(
                heroTag: null,
                autofocus: true,
                highlightElevation: 0,
                splashColor: Theme.of(context).primaryColor,
                onPressed: () => _goToAddOutfit(context),
                label: Text("Add Outfit"),
              )
            : null,
//      resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: currentPage == 0 ? 0 : null,
          title: Text(
            "Outfitter",
            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w400),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _goToSearch(context)),
//TODO: Settings. Themes (light,dark, primary, accent), Add new categories...
//            IconButton(icon: Icon(Icons.settings), onPressed: () {})
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
            activeColor: Colors.white,
            style: TabStyle.reactCircle,
            elevation: 3,
            top: currentPage == 0 ? 0 : -20,
            initialActiveIndex: 1,
            items: [
              TabItem(title: "New", icon: Icons.add),
              TabItem(title: "Items", icon: Icons.style_outlined),
              TabItem(title: "Outfits", icon: Icons.checkroom_rounded),
            ],
            onTap: (int i) {
              controller.animateToPage(i,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            }),
        body: FutureBuilder(
          future: initData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.hasData) {
              return PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                children: <Widget>[
                  AddItemScreen(
                    cameras: widget.cameras,
                    person: person,
                  ),
                  _itemsScreen(),
                  OutfitScreen(person: person),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ));
  }

  void _goToSearch(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchScreen(person: person)));
  }

  void _goToAddOutfit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddOutfitScreen(person: person)));
  }

  Widget _itemsScreen() {
    return SafeArea(
        child: Column(children: [
      const SizedBox(height: 4),
      for (var i in TYPES)
        Expanded(
            child: ItemTile(
          person: person,
          type: i,
        )),
      const SizedBox(height: 4),
    ]));
  }
}
