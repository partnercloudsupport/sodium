import 'package:flutter/material.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/utils/widget_utils.dart';

class MentalHealthPickerBar extends StatefulWidget {
  final Function(int level) onLevelChanged;

  MentalHealthPickerBar({
    this.onLevelChanged,
  });

  @override
  _MentalHealthPickerBarState createState() => _MentalHealthPickerBarState();
}

class _MentalHealthPickerBarState extends State<MentalHealthPickerBar> {
  final levels = [
    MentalHealth.levelSad,
    MentalHealth.levelMeh,
    MentalHealth.levelSmile,
    MentalHealth.levelSmileBeam,
  ];

  int selectedLevel = MentalHealth.levelMeh;

  @override
  Widget build(BuildContext context) {
    final pickers = levels.map((int level) {
      return IconButton(
        alignment: Alignment.center,
        icon: Icon(
          mentalLevelToIconData(level),
          size: 42.0,
          color: selectedLevel == level ? Theme.of(context).primaryColor : Colors.grey.shade400,
        ),
        onPressed: () {
          setState(() {
            selectedLevel = level;
          });

          widget.onLevelChanged(selectedLevel);
        },
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: pickers,
    );
  }
}
