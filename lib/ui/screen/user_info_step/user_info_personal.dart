import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/common/options_bar.dart';
import 'package:sodium/ui/common/ripple_button.dart';

class UserInfoStepPersonal extends StatefulWidget {
  final Function(DateTime, String, String) onSubmit;

  UserInfoStepPersonal({
    this.onSubmit,
  });

  @override
  _UserInfoStepPersonalState createState() => _UserInfoStepPersonalState();
}

class _UserInfoStepPersonalState extends State<UserInfoStepPersonal> {
  TextEditingController _dateOfBirthController;
  TextEditingController _healthConditionController;

  FocusNode _dateOfBirthFocusNode;
  FocusNode _healthConditionFocusNode;

  List<String> _genders = ['ชาย', 'หญิง', 'ไม่ระบุ'];
  String _selectedGender = 'ไม่ระบุ';

  DateTime _dateOfBirth;

  @override
  void initState() {
    super.initState();

    _dateOfBirthFocusNode = FocusNode();
    _healthConditionFocusNode = FocusNode();

    _dateOfBirthController = TextEditingController();
    _healthConditionController = TextEditingController();

    // _dateOfBirthController.text = formatter.format(datetime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'ข้อมูลส่วนตัว',
                            style: Style.titlePrimary,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              locale: 'en',
                              minYear: 1970,
                              maxYear: 2020,
                              initialYear: 1995,
                              initialMonth: 6,
                              initialDate: 21,
                              cancel: Text('ยกเลิก', style: Style.description),
                              confirm: Text('บันทึก', style: Style.descriptionPrimary),
                              dateFormat: 'dd-mmmm-yyyy',
                              onConfirm: (year, month, date) {
                                setState(() {
                                  _dateOfBirth = DateTime(year, month, date);

                                  final formatter = DateFormat('dd MMMM yyyy');
                                  _dateOfBirthController.text = formatter.format(_dateOfBirth);
                                });
                              },
                            );
                          },
                          child: TextField(
                            enabled: false,
                            controller: _dateOfBirthController,
                            focusNode: _dateOfBirthFocusNode,
                            keyboardType: TextInputType.text,
                            decoration: Style.textFieldDecoration.copyWith(labelText: 'วันเกิด (ไม่บังคับกรอก)'),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(_healthConditionFocusNode);
                            },
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextField(
                          controller: _healthConditionController,
                          focusNode: _healthConditionFocusNode,
                          keyboardType: TextInputType.text,
                          decoration: Style.textFieldDecoration.copyWith(labelText: "โรคประจำตัว (ไม่บังคับกรอก)"),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'เพศ',
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.start,
                        ),
                        OptionBar(
                          options: _genders,
                          selectedValue: _selectedGender,
                          onChanged: (String gender) {
                            setState(() {
                              _selectedGender = gender;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            RippleButton(
              text: "ต่อไป",
              backgroundColor: Theme.of(context).primaryColor,
              highlightColor: Palette.highlight,
              textColor: Colors.white,
              onPress: () => widget.onSubmit(_dateOfBirth, _healthConditionController.text, _selectedGender),
            ),
          ],
        ),
      ),
    );
  }
}
