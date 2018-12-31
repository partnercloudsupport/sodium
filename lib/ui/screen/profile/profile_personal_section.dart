import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/common/options_bar.dart';
import 'package:sodium/ui/common/section/section.dart';

class ProfilePersonalSection extends StatefulWidget {
  final String initialName;
  final String initialGender;
  final DateTime initialDateOfBirth;
  final String initialHealthCondition;
  final Function(String, String, DateTime, String) onChanged;

  ProfilePersonalSection({
    this.initialName,
    this.initialGender,
    this.initialDateOfBirth,
    this.initialHealthCondition,
    this.onChanged,
  });

  @override
  _ProfilePersonalSectionState createState() => _ProfilePersonalSectionState();
}

class _ProfilePersonalSectionState extends State<ProfilePersonalSection> {
  TextEditingController _nameController;
  TextEditingController _dateOfBirthController;
  TextEditingController _healthConditionController;

  FocusNode _nameFocusNode;
  FocusNode _dateOfBirthFocusNode;
  FocusNode _healthConditionFocusNode;

  String _selectedGender;
  List<String> _genders = ['ชาย', 'หญิง', 'ไม่ระบุ'];
  DateTime _dateOfBirth;

  @override
  void initState() {
    super.initState();

    _nameFocusNode = FocusNode();
    _dateOfBirthFocusNode = FocusNode();
    _healthConditionFocusNode = FocusNode();

    _nameController = TextEditingController(text: widget.initialName);
    _dateOfBirthController = TextEditingController();
    _healthConditionController = TextEditingController(text: widget.initialHealthCondition);

    if (widget.initialDateOfBirth != null) {
      _dateOfBirth = widget.initialDateOfBirth;

      final datetime = DateTime.now();
      final formatter = DateFormat('dd MMMM yyyy');
      Text(formatter.format(datetime));

      _dateOfBirthController.text = formatter.format(widget.initialDateOfBirth);
    }

    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: Text('ข้อมูลส่วนตัว', style: Style.title),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              keyboardType: TextInputType.text,
              decoration: Style.textFieldDecoration.copyWith(labelText: "ชื่อ - นามสกุล"),
              textInputAction: TextInputAction.next,
              onChanged: (String value) {
                widget.onChanged(_nameController.text, _selectedGender, _dateOfBirth, _healthConditionController.text);
              },
              onSubmitted: (String value) {
                FocusScope.of(context).requestFocus(_dateOfBirthFocusNode);
              },
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
                  onChanged: (year, month, date) {},
                  onConfirm: (year, month, date) {
                    setState(() {
                      _dateOfBirth = DateTime(year, month, date);

                      final formatter = DateFormat('dd MMMM yyyy');
                      _dateOfBirthController.text = formatter.format(_dateOfBirth);
                    });

                    widget.onChanged(_nameController.text, _selectedGender, _dateOfBirth, _healthConditionController.text);
                  },
                );
              },
              child: TextField(
                enabled: false,
                controller: _dateOfBirthController,
                focusNode: _dateOfBirthFocusNode,
                keyboardType: TextInputType.text,
                decoration: Style.textFieldDecoration.copyWith(labelText: 'วันเกิด'),
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
              decoration: Style.textFieldDecoration.copyWith(labelText: "โรคประจำตัว"),
              textInputAction: TextInputAction.next,
              onChanged: (String value) {
                widget.onChanged(_nameController.text, _selectedGender, _dateOfBirth, _healthConditionController.text);
              },
            ),
            SizedBox(height: 12.0),
            Text(
              'เพศ',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.start,
            ),
            OptionBar(
              options: _genders,
              selectedValue: widget.initialGender,
              onChanged: (String gender) {
                setState(() {
                  _selectedGender = gender;
                });

                widget.onChanged(_nameController.text, _selectedGender, _dateOfBirth, _healthConditionController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
