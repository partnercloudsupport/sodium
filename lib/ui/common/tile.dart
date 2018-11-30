import 'package:flutter/material.dart';
import 'package:sodium/ui/common/ripple.dart';

class Tile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget trail;

  final Function onLongPressed;
  final Function onPressed;

  Tile({
    this.onLongPressed,
    this.onPressed,
    this.title,
    this.subtitle,
    this.trail,
  });

  @override
  Widget build(BuildContext context) {
    final heading = Expanded(
      flex: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title,
          subtitle,
        ],
      ),
    );

    final trailing = Expanded(
      flex: 4,
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
      onLongPressed: onLongPressed,
      onPressed: onPressed,
      highlightColor: Colors.white70,
      child: body,
    );
  }
}
