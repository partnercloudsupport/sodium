import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_drawer_handle/modal_drawer_handle.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:redux/redux.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/calendar/calendar.dart';
import 'package:sodium/ui/common/chart/week_chart.dart';
import 'package:sodium/ui/common/chip_selector.dart';
import 'package:sodium/ui/common/food_tile.dart';
import 'package:sodium/ui/common/section_divider.dart';
import 'package:sodium/utils/date_time_util.dart';

class StatsScreen extends StatefulWidget {
  final StatsScreenViewModel viewModel;

  StatsScreen({
    this.viewModel,
  });

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String mode = 'month';
  DateTime thisMonth = DateTime.now();

  void _showFoodList(List<Food> foods, DateTime datetime) {
    final handler = Padding(
      padding: EdgeInsets.all(8.0),
      child: ModalDrawerHandle(
        handleColor: Theme.of(context).primaryColor,
      ),
    );

    final totalSodium = foods.fold(0, (accumulated, food) => food.totalSodium + accumulated);

    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(toThaiDate(datetime), style: title),
        Text('$totalSodium มก.', style: descriptionPrimary),
      ],
    );

    final body = Expanded(
      child: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: FoodTile.selected(food: foods[index]),
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

    showRoundedModalBottomSheet(
      context: context,
      builder: (BuildContext context) => content,
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ChipSelector(
          label: 'กราฟ',
          selected: mode == 'month',
          onTap: () {
            setState(() => mode = 'month');
          },
        ),
        SizedBox(width: 8.0),
        ChipSelector(
          label: 'ปฏิทิน',
          selected: mode == 'week',
          onTap: () {
            setState(() => mode = 'week');
          },
        )
      ],
    );
  }

  Widget _buildChartView() {
    final List<Food> entries = widget.viewModel.entries;
    final thisMonthEntries = entries.where((Food food) => food.dateTime.month == thisMonth.month && food.dateTime.year == thisMonth.year).toList();

    return Column(
      children: <Widget>[
        MonthStrip(
          format: 'MMM yyyy',
          from: DateTime(2016, 4),
          to: thisMonth,
          initialMonth: thisMonth,
          selectedTextStyle: descriptionPrimary,
          normalTextStyle: tileSubtitle,
          height: 42.0,
          viewportFraction: 0.25,
          onMonthChanged: (v) {
            setState(() {
              thisMonth = v;
            });
          },
        ),
        SectionDivider(),
        thisMonthEntries.isNotEmpty
            ? Container(
                height: 256.0,
                child: TimeSeriesBar.withRealData(thisMonth, thisMonthEntries),
              )
            : Expanded(
                child: IconMessage(
                  icon: Icon(FontAwesomeIcons.chartBar, size: 64.0),
                  title: Text('ไม่มีบันทึกในเดือนนี้', style: title),
                  description: Text('กดปุ่มด้านล่างเพื่อเพิ่มบันทึก', style: description),
                ),
              ),
      ],
    );
  }

  Widget _buildCalendarView() {
    final List<Food> entries = widget.viewModel.entries;
    final User user = widget.viewModel.user;

    return Calendar(
      onSelectedRangeChange: (range) {
        setState(() {
          // currentMonth = range.item1;
        });
      },
      isExpandable: true,
      showTodayAction: false,
      showCalendarPickerIcon: false,
      showChevronsToChangeRange: true,
      dayBuilder: (BuildContext context, DateTime datetime) {
        final thisDayEntries = entries.where((Food food) => isSameDate(food.dateTime, datetime)).toList();
        final thisDaySodium = thisDayEntries.fold(0, (int accumulate, Food food) => accumulate + food.totalSodium);
        final belowLimit = thisDaySodium < user.sodiumLimit && thisDaySodium != 0;

        final belowLimitTile = Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.trophy,
              color: belowLimit ? Colors.yellow : Colors.grey.shade200,
              size: 32.0,
            ),
            Positioned(
              left: datetime.day < 10 ? 25 : 20.5,
              bottom: 22,
              child: Text(
                '${datetime.day}',
                style: TextStyle(color: belowLimit ? Colors.white : Colors.grey.shade800),
              ),
            ),
          ],
        );

        final overLimitTile = Container(
          alignment: Alignment.center,
          child: Text('${datetime.day}'),
        );

        return belowLimit ? belowLimitTile : overLimitTile;
      },
      onDateSelected: (DateTime datetime) {
        final thisDayEntries = entries.where((Food food) => isSameDate(food.dateTime, datetime)).toList();

        _showFoodList(thisDayEntries, datetime);
      },
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
              SizedBox(height: 16.0),
              _buildModeSelector(),
              SectionDivider(),
              mode == 'month' ? _buildChartView() : _buildCalendarView(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsScreenViewModel {
  final List<Food> entries;
  final User user;

  StatsScreenViewModel({
    @required this.entries,
    @required this.user,
  });

  static StatsScreenViewModel fromStore(Store<AppState> store) {
    return StatsScreenViewModel(
      entries: store.state.entries,
      user: store.state.user,
    );
  }
}
