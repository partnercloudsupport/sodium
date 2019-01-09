import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/blood_pressures/blood_pressure_action.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/blood_pressure_status.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/common/tile.dart';
import 'package:sodium/ui/screen/blood_pressure_section/blood_presure_create.dart';
import 'package:sodium/utils/date_time_util.dart';
import 'package:sodium/utils/widget_utils.dart';

class BloodPressureScreen extends StatefulWidget {
  static final String route = '/blood_pressure';
  final ProfileBloodPressureSectionViewModel viewModel;

  BloodPressureScreen({
    this.viewModel,
  });

  @override
  _BloodPressureScreenState createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  bool showAllBloodPressureHistory = false;

  void _onSave(BloodPressure bloodPressure) {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(title: 'กำลังบันทึก..'),
      barrierDismissible: false,
    );

    Completer<Null> completer = Completer();
    completer.future.then((_) {
      popDialog(context); // Hide loading;
      popDialog(context); // Hide bottom modal;

      showToast('บันทึกแล้ว');
    }).catchError((error) {
      popDialog(context); // Hide loading;
      showToast('บันทึกไม่สำเร็จ');
    });

    widget.viewModel.onSave(
      bloodPressure,
      completer,
    );
  }

  void _showAddBloodPressure() {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (BuildContext context) => BloodPressureCreate(onSave: _onSave),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloodsPressures = widget.viewModel.bloodPressures;

    return Scaffold(
      appBar: AppBar(
        title: Text('ความดันโลหิต'),
        elevation: 0.3,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBloodPressure(),
        child: Icon(Icons.add),
      ),
      body: bloodsPressures.isNotEmpty
          ? ListView.separated(
              itemBuilder: ((buildContext, index) {
                final bloodPressure = bloodsPressures[index];

                return Tile(
                  padding: EdgeInsets.all(8),
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${bloodPressure.systolic}',
                          style: Style.tileTitle.copyWith(fontSize: 24.0),
                        ),
                        Text(' / ', style: Theme.of(context).textTheme.caption),
                        Text(
                          '${bloodPressure.diastolic}',
                          style: Style.tileTitle.copyWith(fontSize: 24.0),
                        ),
                        Text(' mmHg', style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      BloodPressureLevelBadge(status: bloodPressure.systolicLevel),
                      Text(' / ', style: Theme.of(context).textTheme.caption),
                      BloodPressureLevelBadge(status: bloodPressure.diastolicLevel),
                      SizedBox(width: 8.0),
                    ],
                  ),
                  trail: Text(
                    '${toHumanReadableDate(bloodPressure.dateTime)}',
                    style: Style.tileSubtitle,
                    textAlign: TextAlign.right,
                  ),
                );
              }),
              separatorBuilder: (buildContext, index) {
                return Divider(height: 1.0);
              },
              itemCount: bloodsPressures.length,
            )
          : IconMessage(
              icon: Icon(FontAwesomeIcons.heartbeat, size: 64.0),
              title: Text(
                'ไม่มีบันทึกความดันโลหิต',
                style: Style.title,
              ),
              description: Text(
                'กดปุ่มด้านล่างเพื่อเพิ่ม',
                style: Style.description,
              ),
            ),
    );
  }
}

class ProfileBloodPressureSectionViewModel {
  final List<BloodPressure> bloodPressures;
  final Function(BloodPressure, Completer<Null>) onSave;

  ProfileBloodPressureSectionViewModel({
    this.bloodPressures,
    this.onSave,
  });

  static ProfileBloodPressureSectionViewModel fromStore(Store<AppState> store) {
    return ProfileBloodPressureSectionViewModel(
      bloodPressures: store.state.bloodPressures,
      onSave: (BloodPressure bloodPressure, Completer<Null> completer) => store.dispatch(CreateBloodPressure(bloodPressure, completer)),
    );
  }
}
