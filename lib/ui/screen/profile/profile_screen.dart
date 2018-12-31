import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/user/user_action.dart';
import 'package:sodium/ui/common/dialog/confirm_dialog.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/screen/profile/blood_pressure_section/blood_pressure_section_container.dart';
import 'package:sodium/ui/screen/profile/profile_personal_section.dart';
import 'package:sodium/ui/screen/profile/profile_sodium_section.dart';
import 'package:sodium/utils/widget_utils.dart';

class ProfileScreen extends StatefulWidget {
  static final String route = '/profile';

  final ProfileScreenViewModel viewModel;

  ProfileScreen({
    this.viewModel,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name;
  String _gender;
  DateTime _dateOfBirth;
  String _healthCondition;
  int _sodiumLimit;

  void _save() {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(title: 'กำลังบันทึก..'),
      barrierDismissible: false,
    );

    final user = widget.viewModel.user.copyWith(
      name: _name,
      sodiumLimit: _sodiumLimit,
      gender: _gender,
      dateOfBirth: _dateOfBirth,
      healthCondition: _healthCondition,
    );

    Completer<Null> completer = Completer();
    completer.future.then((_) {
      hideDialog(context);
      showToast('บันทึกแล้ว');
    }).catchError((error) {
      hideDialog(context);
      showToast('บันทึกไม่สำเร็จ');
    });

    widget.viewModel.onSave(user, completer);
  }

  void _logout() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return ConfirmDialog(
            title: 'ออกจากระบบ',
            description: 'คุณต้องการออกจากระบบหรือไม่',
            confirmText: 'ออกจากระบบ',
            cancelText: 'ยกเลิก',
            onCancel: () {
              hideDialog(context);
            },
            onConfirm: () {
              hideDialog(context);
              popScreen(context);
              widget.viewModel.onLogout();
            },
          );
        });
  }

  @override
  void initState() {
    super.initState();
    final user = widget.viewModel.user;

    _name = user.name;
    _sodiumLimit = user.sodiumLimit;
    _gender = user.gender;
    _dateOfBirth = user.dateOfBirth;
    _healthCondition = user.healthCondition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลส่วนตัว"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call_missed_outgoing),
            onPressed: () => _logout(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _save(),
        child: Icon(Icons.done),
      ),
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        children: <Widget>[
          ProfilePersonalSection(
            initialName: _name,
            initialGender: _gender,
            initialDateOfBirth: _dateOfBirth,
            initialHealthCondition: _healthCondition,
            onChanged: (name, gender, dateOfBirth, healthCondition) {
              setState(() {
                _name = name;
                _gender = gender;
                _dateOfBirth = dateOfBirth;
                _healthCondition = healthCondition;
              });
            },
          ),
          ProfileSodiumSection(
            initialSodiumLimit: widget.viewModel.user.sodiumLimit,
            onChanged: (int sodiumLimit) {
              setState(() {
                _sodiumLimit = sodiumLimit;
              });
            },
          ),
          ProfileBloodPressureContainer(),
        ],
      ),
    );
  }
}

class ProfileScreenViewModel {
  final User user;
  final Function(User, Completer<Null>) onSave;
  final Function() onLogout;

  ProfileScreenViewModel({
    this.user,
    this.onSave,
    this.onLogout,
  });

  static ProfileScreenViewModel fromStore(Store<AppState> store) {
    return ProfileScreenViewModel(
      user: store.state.user,
      onSave: (user, completer) => store.dispatch(UpdateUser(user, completer)),
      onLogout: () => store.dispatch(Logout()),
    );
  }
}
