import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:modal_drawer_handle/modal_drawer_handle.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/utils/date_time_util.dart';

class BloodPressureCreate extends StatefulWidget {
  final Function(BloodPressure) onSave;

  BloodPressureCreate({
    this.onSave,
  });

  @override
  _BloodPressureCreateState createState() => _BloodPressureCreateState();
}

class _BloodPressureCreateState extends State<BloodPressureCreate> {
  TextEditingController _systolicController;
  TextEditingController _diastolicController;
  TextEditingController _dateTimeController;

  FocusNode _systolicFocusNode;
  FocusNode _diastolicFocusNode;
  FocusNode _dateTimeFocusNode;

  DateTime _dateTime;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _systolicController = TextEditingController();
    _diastolicController = TextEditingController();

    _dateTime = DateTime.now();
    _dateTimeController = TextEditingController(text: toHumanReadableDate(_dateTime));

    _systolicFocusNode = FocusNode();
    _diastolicFocusNode = FocusNode();
    _dateTimeFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _systolicController.dispose();
    _diastolicController.dispose();

    _systolicFocusNode.dispose();
    _diastolicFocusNode.dispose();
    _dateTimeFocusNode.dispose();
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
        Text('เพิ่มบันทึกความดันโลหิต', style: Style.title),
      ],
    );

    final body = Expanded(
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              focusNode: _systolicFocusNode,
              controller: _systolicController,
              keyboardType: TextInputType.number,
              decoration: Style.textFieldDecoration.copyWith(labelText: "Systolic (เลขบน)"),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(_diastolicFocusNode);
              },
              validator: (String value) => value.isEmpty ? 'กรุณากรอกระดับความดันโลหิต' : null,
            ),
            SizedBox(height: 12.0),
            TextFormField(
              focusNode: _diastolicFocusNode,
              controller: _diastolicController,
              keyboardType: TextInputType.number,
              decoration: Style.textFieldDecoration.copyWith(labelText: "Diastolic (เลขล่าง)"),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) {},
              validator: (String value) => value.isEmpty ? 'กรุณากรอกระดับความดันโลหิต' : null,
            ),
            SizedBox(height: 12.0),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: TextField(
                focusNode: _dateTimeFocusNode,
                controller: _dateTimeController,
                keyboardType: TextInputType.text,
                decoration: Style.textFieldDecoration.copyWith(labelText: 'วันที่'),
                textInputAction: TextInputAction.next,
                enabled: false,
                onSubmitted: (String value) {
                  //  FocusScope.of(context).requestFocus(_healthConditionFocusNode);
                },
              ),
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  locale: 'en',
                  minYear: 1970,
                  maxYear: 2020,
                  initialYear: _dateTime.year,
                  initialMonth: _dateTime.month,
                  initialDate: _dateTime.day,
                  cancel: Text('ยกเลิก', style: Style.description),
                  confirm: Text('บันทึก', style: Style.descriptionPrimary),
                  dateFormat: 'dd-mmmm-yyyy',
                  onChanged: (year, month, date) {},
                  onConfirm: (year, month, date) {
                    setState(() {
                      _dateTime = DateTime(year, month, date);
                      _dateTimeController.text = toHumanReadableDate(_dateTime);
                    });
                  },
                );
              },
            ),
            SizedBox(height: 12.0),
            FlatButton(
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                final systolic = int.parse(_systolicController.text);
                final diastolic = int.parse(_diastolicController.text);
                final bloodPressure = BloodPressure(systolic: systolic, diastolic: diastolic, dateTime: _dateTime);

                widget.onSave(bloodPressure);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.check, color: Theme.of(context).primaryColor),
                  SizedBox(width: 4.0),
                  Text('บันทึก', style: Style.descriptionPrimary),
                ],
              ),
            )
          ],
        ),
      ),
    );

    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          handler,
          header,
          SizedBox(height: 12.0),
          body,
        ],
      ),
    );

    return content;
  }
}
