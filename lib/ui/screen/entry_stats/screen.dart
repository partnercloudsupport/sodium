import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/entry/entry_action.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/calendar/calendar.dart';
import 'package:sodium/ui/common/chart/week_chart.dart';
import 'package:sodium/ui/common/chip.dart';
import 'package:sodium/ui/common/loading/loading_shimmer.dart';
import 'package:sodium/ui/screen/entry_food_list/entry_food_list_container.dart';
import 'package:sodium/utils/date_time_util.dart';

class EntryStatsScreen extends StatefulWidget {
  final EntryStatsScreenViewModel viewModel;

  EntryStatsScreen({
    this.viewModel,
  });

  @override
  _EntryStatsScreenState createState() => _EntryStatsScreenState();
}

class _EntryStatsScreenState extends State<EntryStatsScreen> {
  EntryStateView _view = EntryStateView.chart;
  DateTime _currentMonth = DateTime.now();

  void _showEntryFoods(DateTime datetime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => EntryFoodListContainer(
              dateTime: datetime,
            ),
      ),
    );
  }

  void _setViewMode(EntryStateView view) {
    setState(() {
      _view = view;
    });
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ChipSelector(
          label: 'กราฟ',
          selected: _view == EntryStateView.chart,
          onTap: () => _setViewMode(EntryStateView.chart),
        ),
        SizedBox(width: 8.0),
        ChipSelector(
          label: 'ปฏิทิน',
          selected: _view == EntryStateView.calendar,
          onTap: () => _setViewMode(EntryStateView.calendar),
        )
      ],
    );
  }

  Function(BuildContext, DateTime) _buildCalendarBuilder() {
    return (BuildContext context, DateTime datetime) {
      final thisDayEntries = widget.viewModel.entries.where((Food food) => isSameDate(food.dateTime, datetime)).toList();
      final thisDayTotalSodium = thisDayEntries.fold(0, (int accumulate, Food food) => accumulate + food.totalSodium);

      if (datetime.month != _currentMonth.month) {
        return Container(
          alignment: Alignment.center,
          child: Text('${datetime.day}', style: TextStyle(color: Colors.grey.shade300)),
        );
      }

      final overLimitTile = Container(
        alignment: Alignment.center,
        child: Text('${datetime.day}', style: TextStyle(fontWeight: FontWeight.w500)),
      );

      final belowLimit = thisDayTotalSodium < widget.viewModel.user.sodiumLimit && thisDayTotalSodium != 0;

      final belowLimitTile = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.trophy,
            color: belowLimit ? Colors.yellow : Colors.grey.shade200,
            size: 28.0,
          ),
          Positioned(
            left: datetime.day < 10 ? 24 : 20.5,
            bottom: 20,
            child: Text(
              '${datetime.day}',
              style: TextStyle(color: belowLimit ? Colors.white : Colors.grey.shade800),
            ),
          ),
        ],
      );

      final noEntryTile = Container(
        alignment: Alignment.center,
        child: Text('${datetime.day}', style: TextStyle(color: Colors.grey.shade800)),
      );

      if (thisDayTotalSodium == 0) {
        return GestureDetector(
          onTap: () => _showEntryFoods(datetime),
          child: noEntryTile,
        );
      }

      return GestureDetector(
        onTap: () => _showEntryFoods(datetime),
        child: belowLimit ? belowLimitTile : overLimitTile,
      );
    };
  }

  Widget _buildChartView() {
    final thisMonthEntries = widget.viewModel.entries.where((Food food) => food.dateTime.month == _currentMonth.month && food.dateTime.year == _currentMonth.year).toList();

    return Column(
      children: <Widget>[
        thisMonthEntries.isNotEmpty
            ? Container(
                height: 256.0,
                child: TimeSeriesBar.withRealData(_currentMonth, thisMonthEntries, (DateTime datetime) {
                  _showEntryFoods(datetime);
                }),
              )
            : Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 256.0,
                width: double.infinity,
                child: IconMessage(
                  icon: Icon(FontAwesomeIcons.chartBar, size: 64.0),
                  title: Text('ไม่มีบันทึกในเดือนนี้', style: Style.title),
                  description: Text('กดปุ่มด้านล่างเพื่อเพิ่มบันทึก', style: Style.description),
                ),
              )
      ],
    );
  }

  Widget _buildChartViewSkeleton() {
    return Column(
      children: <Widget>[
        ShimmerLoading.navigationHeader(),
        SizedBox(height: 16.0),
        ShimmerLoading.chart(),
      ],
    );
  }

  Widget _buildCalendarView() {
    return Calendar(
      onSelectedRangeChange: (range) {
        setState(() {
          _currentMonth = range.item1;
        });
      },
      isExpandable: true,
      showTodayAction: false,
      showCalendarPickerIcon: false,
      showChevronsToChangeRange: true,
      dayBuilder: _buildCalendarBuilder(),
      fixedBody: _buildChartView(),
      showFixedBody: _view == EntryStateView.chart,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 4.0),
              _buildModeSelector(),
              SizedBox(height: 4.0),
              widget.viewModel.entries != null ? _buildCalendarView() : _buildChartViewSkeleton(),
            ],
          ),
        ),
      ),
    );
  }
}

class EntryStatsScreenViewModel {
  final List<Food> entries;
  final User user;
  final Function(int, Completer) onDelete;

  EntryStatsScreenViewModel({
    @required this.entries,
    @required this.user,
    @required this.onDelete,
  });

  static EntryStatsScreenViewModel fromStore(Store<AppState> store) {
    return EntryStatsScreenViewModel(
      entries: store.state.entries,
      user: store.state.user,
      onDelete: (int id, Completer completer) => store.dispatch(DeleteEntry(id: id, completer: completer)),
    );
  }
}

enum EntryStateView {
  chart,
  calendar,
}
