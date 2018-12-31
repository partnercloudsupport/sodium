import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/common/options_bar.dart';
import 'package:sodium/ui/common/section/section.dart';

class ProfileSodiumSection extends StatefulWidget {
  final int initialSodiumLimit;
  final Function(int) onChanged;

  ProfileSodiumSection({
    this.initialSodiumLimit,
    this.onChanged,
  });

  @override
  UserSodiumSection createState() {
    return UserSodiumSection();
  }
}

class UserSodiumSection extends State<ProfileSodiumSection> {
  TextEditingController _sodiumLimitController;
  int _selectedSodiumLimit;
  List<int> _sodiumLimits = [1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800];

  @override
  void initState() {
    super.initState();

    _sodiumLimitController = TextEditingController(text: widget.initialSodiumLimit.toString());
    _selectedSodiumLimit = widget.initialSodiumLimit;
  }

  @override
  Widget build(BuildContext context) {
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'ปริมาณโซเดียมต่อวัน',
          style: Theme.of(context).textTheme.caption,
        ),
        Text('มก.', style: Style.tileSubtitle),
      ],
    );

    final input = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: TextField(
            controller: _sodiumLimitController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: Style.textFieldDecoration,
            onChanged: (String value) {
              setState(() {
                _selectedSodiumLimit = int.parse(value);
              });

              widget.onChanged(_selectedSodiumLimit.toInt());
            },
          ),
        ),
        Expanded(
          flex: 8,
          child: OptionBar(
            options: _sodiumLimits.map((value) => value.toString()).toList(),
            selectedValue: _selectedSodiumLimit.toString(),
            onChanged: (String sodiumLimit) {
              setState(() {
                _selectedSodiumLimit = int.parse(sodiumLimit);
                _sodiumLimitController.text = sodiumLimit;
              });

              widget.onChanged(_selectedSodiumLimit.toInt());
            },
          ),
        ),
      ],
    );

    final sodiumSection = SectionContainer(
      title: Text('โซเดียม', style: Style.title),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header,
            input,
          ],
        ),
      ),
    );

    return sodiumSection;
  }
}
