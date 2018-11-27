import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/calendar/calendar.dart';
import 'package:sodium/ui/common/calendar/calendar_tile.dart';
import 'package:sodium/ui/common/mental_overview_item.dart';
import 'package:sodium/utils/date_time_util.dart';
import 'package:sodium/utils/widget_utils.dart';

class MentalHealthScreen extends StatefulWidget {
  final MentalHealthScreenViewModel viewModel;

  MentalHealthScreen({this.viewModel});

  @override
  _MentalHealthScreenState createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  DateTime currentMonth;

  Widget _buildMentalCalendar() {
    return Calendar(
      onSelectedRangeChange: (range) {
        setState(() {
          currentMonth = range.item1;
        });
      },
      isExpandable: true,
      showTodayAction: false,
      showCalendarPickerIcon: false,
      showChevronsToChangeRange: true,
      dayBuilder: (BuildContext context, DateTime datetime) {
        final thisDayMentalHealths = widget.viewModel.mentalHealths.where((MentalHealth mentalHealth) => isSameDate(mentalHealth.datetime, datetime)).toList();

        return MentalCalendarTile(
          isEmpty: thisDayMentalHealths.isEmpty,
          label: datetime.day.toString(),
          color: thisDayMentalHealths.isNotEmpty ? mentalLevelToColor(thisDayMentalHealths.first.level) : Colors.grey.shade300,
        );
      },
      onDateSelected: (DateTime datetime) {
        print(datetime);
      },
    );
  }

  Widget _buildMentalOverview() {
    final thisMonthMentalHealths = widget.viewModel.mentalHealths.where((MentalHealth mentalHealth) => isSameMonth(mentalHealth.datetime, currentMonth)).toList();

    final sadDays = thisMonthMentalHealths.where((MentalHealth mentalHealth) => mentalHealth.level == MentalHealth.levelSad).toList().length;
    final mehDays = thisMonthMentalHealths.where((MentalHealth mentalHealth) => mentalHealth.level == MentalHealth.levelMeh).toList().length;
    final smileDays = thisMonthMentalHealths.where((MentalHealth mentalHealth) => mentalHealth.level == MentalHealth.levelSmile).toList().length;
    final smileBeamDays = thisMonthMentalHealths.where((MentalHealth mentalHealth) => mentalHealth.level == MentalHealth.levelSmileBeam).toList().length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MentalOverviewItem(level: MentalHealth.levelSad, label: '$sadDays วัน'),
        MentalOverviewItem(level: MentalHealth.levelMeh, label: '$mehDays วัน'),
        MentalOverviewItem(level: MentalHealth.levelSmile, label: '$smileDays วัน'),
        MentalOverviewItem(level: MentalHealth.levelSmileBeam, label: '$smileBeamDays วัน'),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildMentalCalendar(),
            SizedBox(height: 24.0),
            _buildMentalOverview(),
          ],
        ),
      ),
    );
  }
}

class MentalHealthScreenViewModel {
  final List<MentalHealth> mentalHealths;

  MentalHealthScreenViewModel({this.mentalHealths});

  static MentalHealthScreenViewModel fromStore(Store<AppState> store) {
    return MentalHealthScreenViewModel(
      mentalHealths: store.state.mentalHealths,
    );
  }
}
