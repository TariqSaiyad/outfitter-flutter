import 'package:Outfitter/models/person.dart';

import '../pages/category_screen.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final dynamic type;
  final Person person;
  final bool isDisplay;

  const ItemTile({Key key, this.type, this.person, this.isDisplay = false})
      : super(key: key);

  const ItemTile.display(
      {Key key, this.type, this.person, this.isDisplay = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: type['name'],
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          height: isDisplay ? 60 : 90,
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
                            settings: RouteSettings(name: 'category_page'),
                            builder: (context) => CategoryScreen(
                                  type: type,
                                  person: person,
                                )),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      isDisplay
                          ? BackButton(
                              color: Colors.white,
                            )
                          : SizedBox(width: 12),
                      Text(
                        type['name'].toString().toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w400,
                            fontSize: isDisplay ? 20 : 24),
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.6),
                        radius: 16,
                        child: Text(
                            person.getCategoryCount(type['name']).toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: isDisplay ? 18 : 20)),
                      ),
                      SizedBox(width: 12)
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
