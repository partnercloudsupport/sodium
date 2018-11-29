import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_drawer_handle/modal_drawer_handle.dart';
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
import 'package:sodium/ui/common/food/food_tile.dart';
import 'package:sodium/ui/common/loading/loading_shimmer.dart';
import 'package:sodium/ui/common/section/section_divider.dart';
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
  StatsView mode = StatsView.chart;
  DateTime thisMonth = DateTime.now();

  void _showFoodList(List<Food> foods, DateTime datetime) {
    final handler = Padding(
      padding: EdgeInsets.all(8.0),
      child: ModalDrawerHandle(
        handleColor: Theme.of(context).primaryColor,
      ),
    );

    final totalSodium = foods.fold(0, (accumulated, food) => food.totalSodium + accumulated);
    final belowLimit = totalSodium < widget.viewModel.user.sodiumLimit && totalSodium != 0;

    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(toThaiDate(datetime), style: title),
            SizedBox(width: 8.0),
            Icon(
              FontAwesomeIcons.medal,
              color: belowLimit ? Colors.yellow : Colors.grey.shade200,
              size: 20.0,
            ),
          ],
        ),
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

      return belowLimit ? belowLimitTile : overLimitTile;
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
                child: TimeSeriesBar.withRealData(thisMonth, thisMonthEntries),
              )
            : Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 256.0,
                width: double.infinity,
                child: IconMessage(
                  icon: Icon(FontAwesomeIcons.chartBar, size: 64.0),
                  title: Text('ไม่มีบันทึกในเดือนนี้', style: title),
                  description: Text('กดปุ่มด้านล่างเพื่อเพิ่มบันทึก', style: description),
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
      onDateSelected: (DateTime datetime) {
        final thisDayEntries = widget.viewModel.entries.where((Food food) => isSameDate(food.dateTime, datetime)).toList();

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

  EntryStatsScreenViewModel({
    @required this.entries,
    @required this.user,
  });

  static EntryStatsScreenViewModel fromStore(Store<AppState> store) {
    return EntryStatsScreenViewModel(
      entries: store.state.entries,
      user: store.state.user,
    );
  }
}

enum StatsView {
  chart,
  calendar,
}
