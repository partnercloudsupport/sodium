import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/ui/common/ripple_button.dart';

class UserInfoBloodPressure extends StatefulWidget {
  final Function(BloodPressure) onSubmit;

  UserInfoBloodPressure({
    this.onSubmit,
  });

  @override
  _UserInfoBloodPressureState createState() => _UserInfoBloodPressureState();
}

class _UserInfoBloodPressureState extends State<UserInfoBloodPressure> {
  TextEditingController _systolicController;
  TextEditingController _diastolicController;

  int _systolic;
  int _diastolic;

  final _formKey = GlobalKey<FormState>();

  void _showSystolicPicker() async {
    final systolic = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 200,
            title: Text("Systolic"),
            initialIntegerValue: _systolic,
            confirmWidget: Text('เลือก'),
            cancelWidget: Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
          );
        });

    if (systolic != null) {
      setState(() {
        _systolic = systolic;
        _systolicController.text = _systolic.toString();
      });
    }
  }

  void _showDiastolicPicker() async {
    final diastolic = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 200,
            title: Text("Diastolic"),
            initialIntegerValue: _diastolic,
            confirmWidget: Text('เลือก'),
            cancelWidget: Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
          );
        });

    if (diastolic != null) {
      setState(() {
        _diastolic = diastolic;
        _diastolicController.text = _diastolic.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _systolic = 120;
    _diastolic = 80;

    _systolicController = TextEditingController();
    _diastolicController = TextEditingController();
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
                    'ระดับความดันโลหิต',
                    style: Style.titlePrimary,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Image.asset(
                    'asset/blood_pressure_close_up.png',
                    height: 180.0,
                  ),
                  SizedBox(height: 32.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Systolic (ตัวเลขด้านบน)', style: Theme.of(context).textTheme.caption),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _showSystolicPicker(),
                                child: TextFormField(
                                  enabled: false,
                                  enableInteractiveSelection: true,
                                  controller: _systolicController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: Style.textFieldDecoration,
                                  textAlign: TextAlign.center,
                                  validator: (String value) => value.isEmpty ? 'กรุณากรอกระดับความดันโลหิต' : null,
                                  style: Theme.of(context).textTheme.subhead.copyWith(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                            Text('มก.', style: Style.description)
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Text('Diastolic  (ตัวเลขด้านล่าง)', style: Theme.of(context).textTheme.caption),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _showDiastolicPicker();
                                },
                                behavior: HitTestBehavior.opaque,
                                child: TextFormField(
                                  enabled: false,
                                  controller: _diastolicController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: Style.textFieldDecoration,
                                  textAlign: TextAlign.center,
                                  validator: (String value) => value.isEmpty ? 'กรุณากรอกระดับความดันโลหิต' : null,
                                  style: Theme.of(context).textTheme.subhead.copyWith(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                            Text('มก.', style: Style.description)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    widget.onSubmit(BloodPressure(systolic: null, diastolic: null));
                  },
                  child: Text('ข้ามไปก่อน', style: Style.descriptionPrimary),
                ),
                SizedBox(height: 16.0),
                RippleButton(
                  text: "ต่อไป",
                  backgroundColor: Theme.of(context).primaryColor,
                  highlightColor: Palette.highlight,
                  textColor: Colors.white,
                  onPress: () {
                    final systolic = int.tryParse(_systolicController.text) ?? null;
                    final diastolic = int.tryParse(_diastolicController.text) ?? null;
                    final bloodPressure = BloodPressure(systolic: systolic, diastolic: diastolic, dateTime: DateTime.now());

                    widget.onSubmit(bloodPressure);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
