import 'package:flutter/material.dart';

class ValueSelector extends StatefulWidget {
  final int min;
  final int max;
  final initial;
  final Function(int value) onValueChange;

  ValueSelector({
    this.min = 1,
    this.max = 7,
    this.initial = 1,
    @required this.onValueChange,
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
      selectors.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedValue = i;
              widget.onValueChange(i);
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CirclePicker(selected: _selectedValue == i ? true : false, content: i.toString()),
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
  final String content;
  final bool selected;

  CirclePicker({
    this.content,
    this.selected,
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
          color: selected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: 3.0,
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          content,
          style: TextStyle(color: selected ? Theme.of(context).primaryColor : Colors.grey.shade300, fontSize: 18.0),
        ),
      ),
    );
  }
}
