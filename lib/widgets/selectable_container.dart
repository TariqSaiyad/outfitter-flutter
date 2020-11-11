library selectable_container;

import 'package:flutter/material.dart';

/// Box that can be tapped.
/// When selected a check Icon appears
class SelectableContainer extends StatefulWidget {
  /// Background color when container is selected.
  /// Default value : dialogBackgroundColor
  final Color selectedBackgroundColor;

  /// Background color when container is not selected.
  /// Default value : dialogBackgroundColor
  final Color unselectedBackgroundColor;

  /// Border color when container is selected.
  /// Default value : primaryColor
  final Color selectedBorderColor;

  /// Border color when container is not selected.
  /// Default value :primaryColorDark
  final Color unselectedBorderColor;

  /// Icon's color
  /// Default value : white
  final Color iconColor;

  /// Icon's size
  /// Default value : 16
  final int iconSize;

  /// The child to render inside the container
  final Widget child;

  /// Border size
  /// Default value : 2 pixels
  final int borderSize;

  /// Callback when container get tapped
  final Function onPressed;

  /// Opacity when container is not selected.
  /// When not 1 it will be animated when tapped.
  /// Default value : 0.5
  final double unselectedOpacity;

  /// Opacity animation duration in milliseconds.
  /// Default value : 600
  final int opacityAnimationDuration;

  /// Icon to be shown when selected.
  /// Default value : Icons.check
  final IconData icon;

  /// Icon position.
  /// Default value : Alignment.topRight
  final Alignment iconAlignment;

  /// Padding of child content
  /// Default value : 0.0
  final double padding;

  /// Elevation
  /// Default value : 0.0
  final double elevation;

  ///Default value : 10.0
  final double borderRadius;

  ///Default not selected
  final bool selected;

  @override
  _SelectableContainerState createState() => _SelectableContainerState();

  SelectableContainer(
      {this.selected,
      this.unselectedBackgroundColor,
      this.selectedBackgroundColor,
      this.selectedBorderColor,
      this.unselectedBorderColor,
      @required this.onPressed,
      this.iconSize = 16,
      this.iconColor = Colors.white,
      this.icon,
      this.iconAlignment = Alignment.topRight,
      this.borderSize = 2,
      this.unselectedOpacity = 0.6,
      this.opacityAnimationDuration = 200,
      this.padding = 0,
      this.elevation = 4.0,
      this.borderRadius = 8.0,
      this.child});
}

class _SelectableContainerState extends State<SelectableContainer> {
  Color _selectedBackgroundColor;
  Color _unselectedBackgroundColor;
  Color _selectedBorderColor;
  Color _unselectedBorderColor;
  IconData _icon;
  bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  void assingDefaultValues() {
    var theme = Theme.of(context);

    _selectedBackgroundColor =
        this.widget.selectedBackgroundColor ?? theme.dialogBackgroundColor;
    _unselectedBackgroundColor =
        this.widget.unselectedBackgroundColor ?? theme.dialogBackgroundColor;
    _selectedBorderColor =
        this.widget.selectedBorderColor ?? theme.primaryColor;

    _unselectedBorderColor =
        this.widget.unselectedBorderColor ?? theme.primaryColorDark;

    _icon = this.widget.icon ?? Icons.check;
  }

  @override
  Widget build(BuildContext context) {
    assingDefaultValues();
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = !_selected;
        });
        widget.onPressed();
      },
      child: AnimatedOpacity(
        opacity: widget.selected ? 1.0 : widget.unselectedOpacity,
        duration: Duration(milliseconds: widget.opacityAnimationDuration),
        child: Material(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          elevation: widget.selected ? widget.elevation : 0,
          child: Stack(
            alignment: widget.iconAlignment,
            children: <Widget>[
              AnimatedContainer(
//                      margin: EdgeInsets.all(widget.iconSize / 2),
//                      padding: EdgeInsets.all(widget.padding),
                child: widget.child,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.selected
                            ? _selectedBorderColor
                            : _unselectedBorderColor,
                        width:
                            widget.selected ? widget.borderSize.toDouble() : 0),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    color: widget.selected
                        ? _selectedBackgroundColor
                        : _unselectedBackgroundColor),
                duration: const Duration(milliseconds: 200),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Visibility(
                  visible: widget.selected,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle,
                      color: widget.selected
                          ? _selectedBorderColor
                          : _unselectedBorderColor,
                    ),
                    child: Icon(
                      _icon,
                      size: widget.iconSize.toDouble(),
                      color: _selectedBorderColor==Colors.white?Colors.black:widget.iconColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
