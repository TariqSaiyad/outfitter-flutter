import 'package:Outfitter/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDialog extends StatefulWidget {
  final Widget content;
  final Widget actions;
  final String title;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final Color titleColor;

  CustomDialog(
      {this.title,
      this.content,
      this.actions,
      this.titleColor,
      this.margin,
      this.padding});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      children: <Widget>[
        Container(
          margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: <Widget>[
              Card(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
//                      color:Colors.white,
//                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(6, 6))
                      ],
                    ),
//                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 40),
                      child: widget.content,
                    ),
                  )),
              _subHeading(context),
              _actions(context),
            ],
          ),
        )
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return widget.actions != null
        ? Positioned.fill(
            child: Container(
                alignment: FractionalOffset.bottomCenter,
                child: widget.actions),
          )
        : SizedBox();
  }

  Widget _subHeading(BuildContext context) {
    return Positioned(
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        alignment: FractionalOffset.centerLeft,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          color: widget.titleColor ?? Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text(
              widget.title,
              style: Styles.text18,
            ),
          ),
        ),
      ),
    );
  }
}
