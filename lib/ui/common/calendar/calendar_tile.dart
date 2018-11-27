import 'package:flutter/material.dart';

class MentalCalendarTile extends StatelessWidget {
  final bool isEmpty;
  final String label;
  final Color color;

  MentalCalendarTile({
    @required this.isEmpty,
    this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: !isEmpty
          ? BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            )
          : null,
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: !isEmpty ? Colors.white : Colors.grey.shade800),
      ),
    );
  }
}
