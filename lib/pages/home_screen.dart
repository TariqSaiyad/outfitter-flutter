import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/pages/outfits_screen.dart';
import 'package:Outfitter/widgets/item_tile.dart';
import 'package:camera/camera.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'add_item_screen.dart';

const List types = [
  {"name": "shirts & tops", "image": "shirts.jpg"},
  {"name": "hoodies", "image": "hoodies.jpg"},
  {"name": "pants", "image": "pants.jpg"},
  {"name": "shorts", "image": "shorts.jpg"},
  {"name": "jackets", "image": "shirts2.jpg"},
  {"name": "shoes", "image": "shoes.jpg"},
  {"name": "accessories", "image": "acc.jpg"},
];

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
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: currentPage);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page.floor();
      });
    });
    person = Person.fromStorage();
    print(person.toString());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
//      resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: currentPage == 0 ? 0 : null,
          title: Text(
            "Outfitter",
            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w400),
          ),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.settings), onPressed: () {})
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
//              TabItem(title: "Add", icon: Icons.add),
              TabItem(title: "Outfits", icon: Icons.checkroom_rounded),
            ],
            onTap: (int i) {
              controller.animateToPage(i,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            }),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: <Widget>[
            AddItemScreen(
              cameras: widget.cameras,
            ),
            ItemsScreen(),
            OutfitScreen(),
          ],
        ));
  }
}

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: types.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemTile(
            type: types[index],
          );
        },
      ),
    );
  }
}
