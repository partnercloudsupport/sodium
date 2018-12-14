import 'package:clippy_flutter/polygon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/constant/styles.dart';

class AchievementItem extends StatelessWidget {
  final bool achieved;
  final String label;
  final bool single;

  AchievementItem({
    this.achieved = false,
    this.label,
    this.single = true,
  });

  AchievementItem.multiple({
    this.achieved = false,
    this.label,
    this.single = false,
  });

  @override
  Widget build(BuildContext context) {
    final multipleContent = Row(
      children: <Widget>[
        Polygon(
          sides: 6,
          child: Container(
            color: achieved ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: 50.0,
            height: 50.0,
            child: Icon(FontAwesomeIcons.trophy, color: achieved ? Colors.yellow : Colors.grey.shade500, size: 20.0),
          ),
        ),
        SizedBox(width: 8.0),
        Text(label, style: achieved ? Style.descriptionPrimary : Style.description),
      ],
    );

    final singleContent = Column(
      children: <Widget>[
        Polygon(
          sides: 6,
          child: Container(
            color: achieved ? Theme.of(context).primaryColor : Colors.grey.shade300,
            width: 70.0,
            height: 70.0,
            child: Icon(FontAwesomeIcons.trophy, color: achieved ? Colors.yellow : Colors.grey.shade500, size: 32.0),
          ),
        ),
        SizedBox(height: 8.0),
        Text(label, style: achieved ? Style.descriptionPrimary : Style.description)
      ],
    );

    return single ? singleContent : multipleContent;
  }
}
