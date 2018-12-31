import 'package:flutter/material.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/common/options_bar.dart';
import 'package:sodium/ui/common/ripple_button.dart';

class UserInfoSodiumLimit extends StatefulWidget {
  final Function(int) onSubmit;

  UserInfoSodiumLimit({
    this.onSubmit,
  });

  @override
  _UserInfoSodiumLimitState createState() => _UserInfoSodiumLimitState();
}

class _UserInfoSodiumLimitState extends State<UserInfoSodiumLimit> {
  TextEditingController _sodiumLimitController;
  List<int> _sodiumLimits = [1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800];
  int _selectedSodiumLimit;

  @override
  void initState() {
    super.initState();

    _selectedSodiumLimit = 2000;
    _sodiumLimitController = TextEditingController(text: _selectedSodiumLimit.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text(
                    'เลือกปริมาณโซเดียมต่อวัน',
                    style: Style.titlePrimary,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.0),
                  Image.asset(
                    AssetImages.sodiumMale,
                    height: 180.0,
                  ),
                  SizedBox(height: 12.0),
                  Form(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _sodiumLimitController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: Style.textFieldDecoration,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subhead.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                            onChanged: (String value) {
                              setState(() {
                                _selectedSodiumLimit = int.parse(value);
                              });
                            },
                          ),
                        ),
                        Text('มก.', style: Style.description)
                      ],
                    ),
                  ),
                  SizedBox(height: 18.0),
                  Text(
                    'หรือเลือก',
                    style: Style.description,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 18.0),
                  OptionBar(
                    options: _sodiumLimits.map((value) => value.toString()).toList(),
                    selectedValue: _selectedSodiumLimit.toString(),
                    onChanged: (String sodiumLimit) {
                      setState(() {
                        _selectedSodiumLimit = int.parse(sodiumLimit);
                        _sodiumLimitController.text = sodiumLimit;
                      });
                    },
                  ),
                ],
              ),
            ),
            RippleButton(
              text: "ต่อไป",
              backgroundColor: Theme.of(context).primaryColor,
              highlightColor: Palette.highlight,
              textColor: Colors.white,
              onPress: () => widget.onSubmit(_selectedSodiumLimit),
            ),
          ],
        ),
      ),
    );
  }
}
