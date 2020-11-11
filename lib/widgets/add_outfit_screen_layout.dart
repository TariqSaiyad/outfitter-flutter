import 'package:flutter/material.dart';

const int NUM_PAGES = 5;

class AddOutfitScreenLayout extends StatelessWidget {
  final String title;
  final String subtitle;

  final Function rightFn;
  final Function leftFn;

  final Color leftCol;
  final Color rightCol;

  final Icon rightIcon;
  final Icon leftIcon;
  final int pageIndex;
  final Widget widget;
  final bool hasBackButton;

  const AddOutfitScreenLayout(
      {Key key,
      this.title,
      this.rightFn,
      this.leftFn,
      this.widget,
      this.pageIndex = 0,
      this.subtitle,
      this.leftCol,
      this.hasBackButton = false,
      this.rightCol,
      this.rightIcon,
      this.leftIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            hasBackButton
                ? Align(alignment: Alignment.centerLeft, child: BackButton())
                : SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                title ?? "No Title",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(letterSpacing: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: Theme.of(context).accentColor,
              thickness: 2,
//              indent: 4,
//              endIndent: 4,
            ),
            subtitle != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(letterSpacing: 1),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox(),
            Expanded(child: widget ?? Container(color: Colors.yellow)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                leftFn != null
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: leftCol ?? null,
                            splashColor: Theme.of(context).primaryColor,
                            onPressed: leftFn,
                            child: leftIcon ?? const Icon(Icons.chevron_left),
                          ),
                        ),
                      )
                    : const Spacer(),
                Row(
                    children: List.generate(NUM_PAGES,
                        (i) => IndicatorCircle(page: pageIndex, index: i))),
                rightFn != null
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: rightCol ?? null,
                            splashColor: Theme.of(context).primaryColor,
                            onPressed: rightFn,
                            child: rightIcon ?? const Icon(Icons.chevron_right),
                          ),
                        ),
                      )
                    : const Spacer()
              ],
            )
          ],
        ),
      ),
    );
  }
}

class IndicatorCircle extends StatelessWidget {
  final int index;
  final int page;

  const IndicatorCircle({Key key, this.index, this.page}) : super(key: key);

  bool current() {
    return index == page;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color:
                Theme.of(context).accentColor.withOpacity(current() ? 1 : 0.5),
            shape: BoxShape.circle),
        height: current() ? 8 : 4,
        width: current() ? 8 : 4,
      ),
    );
  }
}
