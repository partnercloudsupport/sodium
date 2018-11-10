import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrophyStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Trophy(achieved: true),
        Trophy(),
        Trophy(),
        Trophy(achieved: true),
        Trophy(achieved: true),
        Trophy(achieved: true),
        Trophy(),
      ],
    );
  }
}

class Trophy extends StatelessWidget {
  final bool achieved;
  final String label;

  Trophy({
    this.label = 'ว',
    this.achieved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('จ', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        Icon(FontAwesomeIcons.trophy, color: achieved ? Colors.yellow : Colors.grey.shade300),
      ],
    );
  }
}
