import 'package:flutter/material.dart';

class ValueSelector extends StatefulWidget {
  final int min;
  final int max;
  final initial;
  final int excessValue;
  final int values;
  final Function(int value) onValueChange;
  final Color inactiveColor;
  final Color activeColor;

  ValueSelector({
    this.min = 1,
    this.max = 7,
    this.excessValue = 2500,
    this.initial = 1,
    this.activeColor,
    this.inactiveColor,
    @required this.onValueChange,
    this.values,
  });

  @override
  _ValueSelectorState createState() => _ValueSelectorState();
}

class _ValueSelectorState extends State<ValueSelector> {
  int _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    final List<Widget> selectors = [];
    for (int i = 1; i <= widget.max; ++i) {
      final bool excess = (i * widget.values) > widget.excessValue;

      selectors.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedValue = i;
              widget.onValueChange(i);
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CirclePicker(
              inactiveColor: excess ? Colors.red.shade100 : widget.inactiveColor,
              activeColor: excess ? Colors.redAccent : widget.activeColor,
              selected: _selectedValue == i ? true : false,
              label: i.toString(),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 40.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: selectors,
      ),
    );
  }
}

class CirclePicker extends StatelessWidget {
  final String label;
  final bool selected;
  final Color inactiveColor;
  final Color activeColor;

  CirclePicker({
    this.label,
    this.selected,
    this.inactiveColor,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 36.0,
        minHeight: 36.0,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? activeColor : inactiveColor,
          width: 3.0,
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: selected ? activeColor : inactiveColor,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
