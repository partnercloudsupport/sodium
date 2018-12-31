import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/constant/styles.dart';

class Trophy extends StatelessWidget {
  final TrophyMode mode;
  final String day;
  final bool today;
  final int date;

  Trophy({
    this.day = 'ว',
    this.mode = TrophyMode.failed,
    this.today = false,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(day, style: Style.tileSubtitle),
            mode == TrophyMode.noData
                ? Icon(
                    Icons.add,
                    color: Colors.grey.shade300,
                  )
                : Icon(
                    FontAwesomeIcons.trophy,
                    color: mode == TrophyMode.achieved ? Colors.yellow : Colors.grey.shade300,
                  ),
            SizedBox(height: 4.0),
            Text(today ? 'วันนี้' : '', style: Style.tileSubtitle),
          ],
        )
      ],
    );
  }
}

enum TrophyMode {
  achieved,
  failed,
  noData,
}
