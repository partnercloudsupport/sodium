import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/mental/mental_action.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/common/mental_health/mental_health_picker_bar.dart';
import 'package:sodium/ui/common/ripple_button.dart';
import 'package:sodium/utils/widget_utils.dart';

class MentalHealthSurveyScreen extends StatefulWidget {
  final MentalHealthSurveyScreenViewModel viewModel;

  MentalHealthSurveyScreen({this.viewModel});

  @override
  _MentalHealthSurveyScreenState createState() => _MentalHealthSurveyScreenState();
}

class _MentalHealthSurveyScreenState extends State<MentalHealthSurveyScreen> {
  int mentalHealthLevel = MentalHealth.levelSmile;

  void _save() {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(title: 'กำลังบันทึก'),
      barrierDismissible: false,
    );

    final mentalHealth = MentalHealth(
      level: mentalHealthLevel,
      datetime: DateTime.now(),
    );

    final Completer<Null> completer = Completer();
    completer.future.then((_) {
      hideDialog(context);
      popScreen(context);
      showToast('บันทึกแล้ว');
    }).catchError((error) {
      hideDialog(context);
      showToast('บันทึกไม่สำเร็จ ลองอีกครั้ง');
    });

    widget.viewModel.onSave(mentalHealth, completer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แบบทดสอบความสุข'),
        elevation: 0.5,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'วันนี้คุณมีความสุขแค่ไหน?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28.0, color: Colors.grey.shade800),
                ),
                Text(
                  'เลือกระดับความสุขด่านล่าง',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, color: Colors.grey.shade500),
                ),
                SizedBox(height: 32.0),
                MentalHealthPickerBar(
                  onLevelChanged: (int level) {
                    setState(() {
                      mentalHealthLevel = level;
                    });
                  },
                ),
              ],
            ),
//            SizedBox(height: 32.0),
            RippleButton(
              text: "บันทึก",
              backgroundColor: Theme.of(context).primaryColor,
              highlightColor: Colors.greenAccent.shade400,
              textColor: Colors.white,
              onPress: () => _save(),
            ),
          ],
        ),
      ),
    );
  }
}

class MentalHealthSurveyScreenViewModel {
  final Function(MentalHealth meantalHealth, Completer<Null> completer) onSave;

  MentalHealthSurveyScreenViewModel({
    this.onSave,
  });

  static MentalHealthSurveyScreenViewModel fromStore(Store<AppState> store) {
    return MentalHealthSurveyScreenViewModel(
      onSave: (MentalHealth mentalHealth, Completer<Null> completer) => store.dispatch(CreateMentalHealth(mentalHealth, completer)),
    );
  }
}
