import 'package:flutter/material.dart';
import 'package:sodium/ui/common/ripple.dart';

class Tile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget trail;

  final Function onLongPressed;
  final Function onPressed;
  final EdgeInsets padding;
  final Color backgroundColor;

  Tile({
    this.onLongPressed,
    this.onPressed,
    this.title,
    this.subtitle,
    this.trail,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final heading = Expanded(
      flex: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title ?? Container(),
          subtitle ?? Container(),
        ],
      ),
    );

    final trailing = Expanded(
      flex: 5,
      child: trail,
    );

    final body = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        heading,
        trailing ?? Container(),
      ],
    );

    return RippleContainer(
      padding: padding,
      onLongPressed: onLongPressed,
      onPressed: onPressed,
      highlightColor: Colors.white70,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: body,
    );
  }
}
