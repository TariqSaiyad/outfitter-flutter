import '../pages/category_screen.dart';
import 'package:flutter/material.dart';
import '../pages/home_screen.dart';

class ItemTile extends StatelessWidget {
  final dynamic type;
  final bool isDisplay;

  const ItemTile({Key key, this.type, this.isDisplay = false})
      : super(key: key);

  const ItemTile.display({Key key, this.type, this.isDisplay = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: type['name'],
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          height: isDisplay ? 60 : 90,
//          duration: const Duration(seconds: 1),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              child: Ink.image(
                image: AssetImage('assets/${type['image']}'),
                fit: BoxFit.cover,
                child: InkWell(
                  splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                  onTap: () {
                    if (!isDisplay) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen(type: type)),
                      );
                    }
                  },
                  child: Center(
                      child: Text(
                    type['name'].toString().toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w400,
                        fontSize: isDisplay ? 20 : 24),
                  )),
                ),
              ),
            ),
          )),
    );
  }
}
