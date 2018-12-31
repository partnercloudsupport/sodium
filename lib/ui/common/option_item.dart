import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';

class OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  OptionItem({
    this.icon,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon),
        SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Style.tileTitle),
            Text(description, style: Style.description),
          ],
        )
      ],
    );
  }
}
