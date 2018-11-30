import 'package:flutter/material.dart';
import 'package:sodium/ui/common/chip.dart';

class ChipBar extends StatefulWidget {
  final List<String> items;

  ChipBar({
    this.items,
  });

  @override
  _ChipBarState createState() => _ChipBarState();
}

class _ChipBarState extends State<ChipBar> {
  List<String> selectedItem = [];

  Widget _buildChip(String label, bool selected) {
    return ChipSelector(
      label: label,
      selected: selected,
      onTap: () {
        if (selectedItem.contains(label)) {
          setState(() {
            selectedItem.remove(label);
          });
        } else {
          setState(() {
            selectedItem.add(label);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];
          final selected = selectedItem.contains(item);

          return _buildChip(item, selected);
        },
      ),
    );
  }
}
