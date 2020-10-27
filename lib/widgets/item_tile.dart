import '../pages/items_screen.dart';
import 'package:flutter/material.dart';
import '../pages/home_screen.dart';

class ItemTile extends StatelessWidget {
  final int index;

  const ItemTile({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        height: 90,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Ink.image(
            image: AssetImage('assets/${types[index]['image']}'),
            fit: BoxFit.cover,
            child: InkWell(
              splashColor: Theme.of(context).accentColor.withOpacity(0.3),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemsScreen(type: types[index])),
                );
              },
              child: Center(
                  child: Text(
                types[index]['name'].toString().toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w400,
                    fontSize: 24),
              )),
            ),
          ),
        ));
  }
}
