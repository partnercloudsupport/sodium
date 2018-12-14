import 'package:flutter/material.dart';
import 'package:modal_drawer_handle/modal_drawer_handle.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/data/model/unit.dart';
import 'package:sodium/ui/common/chip.dart';
import 'package:sodium/ui/common/number_bar.dart';

class SeasoningOptions extends StatefulWidget {
  final Function(double amount, Unit unit) onSave;
  final Seasoning seasoning;

  SeasoningOptions({
    @required this.onSave,
    @required this.seasoning,
  });

  @override
  SeasoningOptionsState createState() {
    return new SeasoningOptionsState();
  }
}

class SeasoningOptionsState extends State<SeasoningOptions> {
  final units = [
    Unit(name: 'ช้อนชา', multiplier: 1),
    Unit(name: 'ช้อนโต๊ะ', multiplier: 3),
    Unit(name: 'ถ้วย', multiplier: 48),
  ];

  Unit selectedUnit;
  double selectedAmount;

  Widget _buildChipUnitItem(Unit unit, bool selected) {
    final handleOnSelect = () {
      setState(() {
        selectedUnit = unit;
      });
    };

    final chip = ChipSelector(
      label: unit.name,
      selected: selected,
      onTap: handleOnSelect,
    );

    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: chip,
    );
  }

  @override
  void initState() {
    selectedAmount = 1;
    selectedUnit = units.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final handler = Padding(
      padding: EdgeInsets.all(8.0),
      child: ModalDrawerHandle(
        handleColor: Theme.of(context).primaryColor,
      ),
    );

    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${widget.seasoning.name}', style: Style.titlePrimary),
            SizedBox(width: 4.0),
            Text('โซเดียม ${widget.seasoning.sodiumPerTeaspoon * (selectedAmount * selectedUnit.multiplier).toInt()} มก.', style: Style.description),
          ],
        ),
        FlatButton(
          onPressed: () => widget.onSave(selectedAmount, selectedUnit),
          child: Row(
            children: <Widget>[
              Icon(Icons.check, color: Theme.of(context).primaryColor),
              SizedBox(width: 4.0),
              Text('บันทึก', style: Style.descriptionPrimary),
            ],
          ),
        )
      ],
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('ปริมาณ', style: Style.descriptionPrimary),
        SizedBox(height: 4.0),
        NumberBar(
          initial: selectedAmount,
          min: 1,
          max: 15,
          values: 2,
          excessValue: 2000,
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Colors.grey.shade300,
          onValueChange: (value) {
            setState(() {
              selectedAmount = value;
            });
          },
        ),
        SizedBox(height: 14.0),
        Text('หน่วย', style: Style.descriptionPrimary),
        SizedBox(height: 4.0),
        Container(
          height: 36.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: units.length,
            itemBuilder: (BuildContext context, int index) {
              final unit = units[index];
              final bool selected = selectedUnit == unit;

              return _buildChipUnitItem(unit, selected);
            },
          ),
        ),
      ],
    );

    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          handler,
          header,
          SizedBox(height: 14.0),
          body,
          SizedBox(height: 14.0),
        ],
      ),
    );

    return content;
  }
}
