import 'package:flutter/material.dart';
import 'package:sodium/utils/string_util.dart';

// 1/8 1/4 1/3 3/8 1/2 5/8 2/3 3/4 7/8
class NumberBar extends StatefulWidget {
  final int min;
  final int max;
  final initial;
  final int excessValue;
  final int values;
  final Function(double value) onValueChange;
  final Color inactiveColor;
  final Color activeColor;

  NumberBar({
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
  _NumberBarState createState() => _NumberBarState();
}

class _NumberBarState extends State<NumberBar> {
  double _selectedValue = 1;

  List<double> _fractionNumbers = [
    0.125,
    0.25,
    0.33,
    0.375,
    0.5,
    0.625,
    0.66,
    0.75,
    0.875,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> selectors = [];

    _fractionNumbers.forEach((i) {
      final bool excess = (i * widget.values) > widget.excessValue;

      selectors.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedValue = i;
            });

            widget.onValueChange(i.toDouble());
          },
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CirclePicker(
              inactiveColor: excess ? Colors.red.shade100 : widget.inactiveColor,
              activeColor: excess ? Colors.redAccent : widget.activeColor,
              selected: _selectedValue == i ? true : false,
              label: decimalToFraction(i),
            ),
          ),
        ),
      );
    });

    for (int i = 1; i <= widget.max; ++i) {
      final bool excess = (i * widget.values) > widget.excessValue;

      selectors.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedValue = i.toDouble();
            });

            widget.onValueChange(i.toDouble());
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
