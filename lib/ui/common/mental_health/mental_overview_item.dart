import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';
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
      width: 45,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: mentalLevelToColor(level)),
      child: Icon(
        mentalLevelToIconData(level),
        color: Colors.white,
        size: 32.0,
      ),
    );

    final text = Text(
      '$label',
      style: Style.description,
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
