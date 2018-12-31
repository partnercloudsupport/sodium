import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/blood_pressures/blood_pressure_action.dart';
import 'package:sodium/redux/user/user_action.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/screen/main/screen.dart';
import 'package:sodium/ui/screen/user_info_step/user_info_blood_pressure.dart';
import 'package:sodium/ui/screen/user_info_step/user_info_personal.dart';
import 'package:sodium/ui/screen/user_info_step/user_info_sodium_limit.dart';
import 'package:sodium/utils/widget_utils.dart';

class UserInfoStepScreen extends StatefulWidget {
  static final String route = 'user_info_step';

  final UserStepInfoScreeViewModel viewModel;

  UserInfoStepScreen({
    this.viewModel,
  });

  @override
  _UserInfoStepScreenState createState() => _UserInfoStepScreenState();
}

class _UserInfoStepScreenState extends State<UserInfoStepScreen> {
  PageController _pageController;

  DateTime _dateOfBirth;
  String _healthCondition;
  String _gender;
  int _sodiumLimit;
  BloodPressure _bloodPressure;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);
  }

  void _showMainScreen() {
    Navigator.of(context).pushReplacementNamed(MainScreen.route);
  }

  void _saveUserProfile() {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(title: 'กำลังบันทึก..'),
      barrierDismissible: false,
    );

    Completer<Null> userProfileCompleter = Completer();
    userProfileCompleter.future.then((_) {
      hideDialog(context);
      showToast('บันทึกแล้ว');

      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.linear,
      );
    }).catchError((error) {
      hideDialog(context);
      showToast('บันทึกไม่สำเร็จ');
    });

    final user = widget.viewModel.user.copyWith(
      dateOfBirth: _dateOfBirth,
      healthCondition: _healthCondition,
      gender: _gender,
      sodiumLimit: _sodiumLimit,
      isNewUser: false,
    );

    widget.viewModel.onSaveUserProfile(user, userProfileCompleter);
  }

  void _saveBloodPressure() {
    if (_bloodPressure.diastolic != null || _bloodPressure.systolic != null) {
      showDialog(
        context: context,
        builder: (context) => LoadingDialog(title: 'กำลังบันทึก..'),
        barrierDismissible: false,
      );

      Completer<Null> bloodPressureCompleter = Completer();
      bloodPressureCompleter.future.then((_) {
        hideDialog(context);
        showToast('บันทึกแล้ว');

        popScreen(context);
      }).catchError((error) {
        hideDialog(context);
        showToast('บันทึกไม่สำเร็จ');
      });

      widget.viewModel.onCreateBloodPressure(_bloodPressure, bloodPressureCompleter);
    } else {
      popScreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        UserInfoStepPersonal(
          onSubmit: (dateOfBirth, healthCondition, gender) {
            setState(() {
              _dateOfBirth = dateOfBirth;
              _healthCondition = healthCondition;
              _gender = gender;
            });

            _pageController.nextPage(
              duration: Duration(milliseconds: 400),
              curve: Curves.linear,
            );
          },
        ),
        UserInfoSodiumLimit(
          onSubmit: (sodiumLimit) {
            setState(() {
              _sodiumLimit = sodiumLimit;
            });

            _saveUserProfile();
          },
        ),
        UserInfoBloodPressure(
          onSubmit: (bloodPressure) {
            setState(() {
              _bloodPressure = bloodPressure;
            });

            _saveBloodPressure();
          },
        ),
      ],
    );
  }
}

class UserStepInfoScreeViewModel {
  final Function(User, Completer<Null>) onSaveUserProfile;
  final Function(BloodPressure, Completer<Null>) onCreateBloodPressure;
  final User user;

  UserStepInfoScreeViewModel({
    this.onSaveUserProfile,
    this.onCreateBloodPressure,
    this.user,
  });

  static UserStepInfoScreeViewModel fromStore(Store<AppState> store) {
    return UserStepInfoScreeViewModel(
      onSaveUserProfile: (User user, Completer<Null> completer) => store.dispatch(UpdateUser(user, completer)),
      onCreateBloodPressure: (BloodPressure bloodPressure, Completer<Null> completer) => store.dispatch(CreateBloodPressure(bloodPressure, completer)),
      user: store.state.user,
    );
  }
}
