import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final Widget title;
  final Widget info;

  InfoItem({
    this.title,
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        title,
        info,
      ],
    );
  }
}
