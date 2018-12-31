import 'package:flutter/material.dart';
import 'package:sodium/ui/common/chip.dart';

class OptionBar extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final Function(String) onChanged;

  OptionBar({
    @required this.options,
    @required this.onChanged,
    @required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: options.map((String value) {
          return Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: ChipSelector(
              label: '$value',
              selected: selectedValue == value,
              onTap: () {
                onChanged(value);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
