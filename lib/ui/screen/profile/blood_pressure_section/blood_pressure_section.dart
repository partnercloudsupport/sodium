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
import 'package:sodium/ui/common/section/section.dart';
import 'package:sodium/ui/common/tile.dart';
import 'package:sodium/ui/screen/profile/blood_pressure_section/blood_presure_create.dart';
import 'package:sodium/utils/date_time_util.dart';
import 'package:sodium/utils/widget_utils.dart';

class ProfileBloodPressureSection extends StatefulWidget {
  final ProfileBloodPressureSectionViewModel viewModel;

  ProfileBloodPressureSection({
    this.viewModel,
  });

  @override
  _ProfileBloodPressureSectionState createState() => _ProfileBloodPressureSectionState();
}

class _ProfileBloodPressureSectionState extends State<ProfileBloodPressureSection> {
  bool showAllBloodPressureHistory = false;

  void _onSave(BloodPressure bloodPressure) {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(title: 'กำลังบันทึก..'),
      barrierDismissible: false,
    );

    Completer<Null> completer = Completer();
    completer.future.then((_) {
      hideDialog(context); // Hide loading;
      hideDialog(context); // Hide bottom modal;

      showToast('บันทึกแล้ว');
    }).catchError((error) {
      hideDialog(context); // Hide loading;
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
    final bloodPressuresToShow = bloodsPressures.take(showAllBloodPressureHistory ? bloodsPressures.length : 3);

    return SectionContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('ความดันเลือด', style: Style.title),
          GestureDetector(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  'เพิ่มบันทึก',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
            onTap: () {
              _showAddBloodPressure();
            },
          ),
        ],
      ),
      body: bloodsPressures.isNotEmpty
          ? Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bloodPressuresToShow.map((BloodPressure bloodPressure) {
                    return Column(
                      children: [
                        Tile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '${bloodPressure.systolic}',
                                  style: Theme.of(context).textTheme.subhead,
                                ),
                                Text('/', style: Theme.of(context).textTheme.caption),
                                Text(
                                  '${bloodPressure.diastolic}',
                                  style: Theme.of(context).textTheme.subhead,
                                ),
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
                            style: Style.tileTrailing,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }).toList(),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      showAllBloodPressureHistory = !showAllBloodPressureHistory;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.view_list, color: Theme.of(context).primaryColor),
                      SizedBox(width: 4.0),
                      Text(showAllBloodPressureHistory ? 'แสดง 3 รายการล่าสุด' : 'แสดงทั้งหมด', style: Style.descriptionPrimary),
                    ],
                  ),
                )
              ],
            )
          : IconMessage(
              icon: Icon(
                FontAwesomeIcons.list,
                size: 32.0,
                color: Colors.grey,
              ),
              title: Text(
                'ไม่มีบันทึกในเดือนนี้',
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
