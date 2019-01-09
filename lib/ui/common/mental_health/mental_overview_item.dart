import 'package:flutter/material.dart';
import 'package:sodium/utils/widget_utils.dart';

class MentalOverviewItem extends StatelessWidget {
  final int level;
  final String label;

  MentalOverviewItem({
    this.level,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final face = Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: mentalLevelToColor(level)),
      child: Icon(
        mentalLevelToIconData(level),
        color: Colors.white,
        size: 25.0,
      ),
    );

    final text = Text(
      '$label',
      style: TextStyle(color: Colors.grey.shade800),
//      style: Style.description,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        face,
        SizedBox(height: 4.0),
        text,
      ],
    );
  }
}
