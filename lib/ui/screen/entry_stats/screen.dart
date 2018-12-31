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
import 'package:sodium/ui/common/dialog/confirm_dialog.dart';
import 'package:sodium/ui/common/food/food_list_entry.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/common/loading/loading_shimmer.dart';
import 'package:sodium/ui/common/option_item.dart';
import 'package:sodium/utils/date_time_util.dart';
import 'package:sodium/utils/widget_utils.dart';

class EntryStatsScreen extends StatefulWidget {
  final EntryStatsScreenViewModel viewModel;

  EntryStatsScreen({
    this.viewModel,
  });

  @override
  _EntryStatsScreenState createState() => _EntryStatsScreenState();
}

class _EntryStatsScreenState extends State<EntryStatsScreen> {
  StatsView mode = StatsView.chart;
  DateTime thisMonth = DateTime.now();
  bool showCalendar = false;

  void _showOptions(Food food) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalBottomSheetContext) => ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  print('edit');
                },
                title: OptionItem(
                  icon: Icons.edit,
                  title: 'แก้ไข',
                  description: 'แก้ไขรายการอาหาร',
                ),
              ),
              ListTile(
                onTap: () {
                  hideDialog(context); // Hide confirm dialog

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return ConfirmDialog(
                          title: 'ต้องการลบหรือไม่',
                          description: 'ข่าวสารจะหายไปและไม่สามารถกู้คืนได้',
                          confirmText: 'ลบ',
                          cancelText: 'ยกเลิก',
                          onCancel: () {
                            hideDialog(context); // Hide confirm dialog
                          },
                          onConfirm: () {
                            hideDialog(context); // Hide confirm dialog

                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return LoadingDialog(title: 'กำลังลบข่าวสาร');
                              },
                            );

                            Completer<Null> completer = Completer();
                            completer.future.then((_) {
                              hideDialog(context); // Hide LoadingDialog
                              popScreen(context);

                              showToast("ลบข่าวสารแล้ว");
                            });

                            widget.viewModel.onDelete(food.entryId, completer);
                          },
                        );
                      });
                },
                title: OptionItem(
                  icon: Icons.delete,
                  title: 'ลบ',
                  description: 'ลบรายการอาหาร',
                ),
              ),
            ],
          ),
    );
  }

  void _showFoodList(DateTime datetime) {
    final selectedDayFoods = widget.viewModel.entries.where((Food food) => isSameDate(food.dateTime, datetime)).toList();
    final totalSodium = selectedDayFoods.fold(0, (accumulated, food) => food.totalSodium + accumulated);
    final achieved = totalSodium < widget.viewModel.user.sodiumLimit && totalSodium != 0;

    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => FoodListEntry(
              foods: selectedDayFoods,
              datetime: datetime,
              achieved: achieved,
              onLongPressed: (Food food) => _showOptions(food),
            ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ChipSelector(
          label: 'กราฟ',
          selected: mode == StatsView.chart,
          onTap: () {
            setState(() => mode = StatsView.chart);
          },
        ),
        SizedBox(width: 8.0),
        ChipSelector(
          label: 'ปฏิทิน',
          selected: mode == StatsView.calendar,
          onTap: () {
            setState(() => mode = StatsView.calendar);
          },
        )
      ],
    );
  }

  Function(BuildContext, DateTime) _buildCalendarBuilder() {
    return (BuildContext context, DateTime datetime) {
      final thisDayEntries = widget.viewModel.entries.where((Food food) => isSameDate(food.dateTime, datetime)).toList();
      final thisDaySodium = thisDayEntries.fold(0, (int accumulate, Food food) => accumulate + food.totalSodium);
      final belowLimit = thisDaySodium < widget.viewModel.user.sodiumLimit && thisDaySodium != 0;

      final belowLimitTile = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.trophy,
            color: belowLimit ? Colors.yellow : Colors.grey.shade200,
            size: 28.0,
          ),
          Positioned(
            left: datetime.day < 10 ? 25 : 20.5,
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
        child: Text('${datetime.day}', style: TextStyle(color: Colors.grey.shade300)),
      );

      final overLimitTile = Container(
        alignment: Alignment.center,
        child: Text('${datetime.day}', style: TextStyle(fontWeight: FontWeight.w500)),
      );

      if (thisDaySodium == 0) {
        return noEntryTile;
      }

      return GestureDetector(
        onTap: () => _showFoodList(datetime),
        child: belowLimit ? belowLimitTile : overLimitTile,
      );
    };
  }

  Widget _buildChartView() {
    final List<Food> entries = widget.viewModel.entries;
    final thisMonthEntries = entries.where((Food food) => food.dateTime.month == thisMonth.month && food.dateTime.year == thisMonth.year).toList();

    return Column(
      children: <Widget>[
        thisMonthEntries.isNotEmpty
            ? Container(
                height: 256.0,
                child: TimeSeriesBar.withRealData(thisMonth, thisMonthEntries, (DateTime datetime) {
                  _showFoodList(datetime);
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

  Widget _buildChartViewLoading() {
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
          thisMonth = range.item1;
        });
      },
      isExpandable: true,
      showTodayAction: false,
      showCalendarPickerIcon: false,
      showChevronsToChangeRange: true,
      dayBuilder: _buildCalendarBuilder(),
      fixedBody: _buildChartView(),
      showFixedBody: mode == StatsView.chart,
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('สถิติ'),
        elevation: .3,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 4.0),
              _buildModeSelector(),
              SizedBox(height: 4.0),
              widget.viewModel.entries != null ? _buildCalendarView() : _buildChartViewLoading(),
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

enum StatsView {
  chart,
  calendar,
}
