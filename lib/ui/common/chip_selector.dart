import 'package:flutter/material.dart';

class ChipSelector extends StatelessWidget {
  final Function onTap;
  final bool selected;
  final String label;

  const ChipSelector({
    this.onTap,
    this.selected,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Chip(
          shape: StadiumBorder(),
          backgroundColor: selected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          label: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.grey.shade500)),
        ),
      ),
    );
  }
}
