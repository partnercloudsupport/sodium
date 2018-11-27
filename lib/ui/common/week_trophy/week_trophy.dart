import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/loading/shimmer.dart';
import 'package:sodium/utils/date_time_util.dart';

class WeekTrophy extends StatelessWidget {
  final WeekTrophyViewModel viewModel;

  WeekTrophy({this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.entries == null) {
      return ShimmerLoading.header();
    }

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = now.add(Duration(days: 7 - now.weekday));
    final range = weekEnd.difference(weekStart).inDays;

    final thisWeekEntries = viewModel.entries.where((Food food) => isSameOrBetweenDate(datetime: food.dateTime, from: weekStart, to: weekEnd)).toList();

    final List<Widget> trophies = [];
    for (int day = weekStart.day; day <= weekStart.day + range; day++) {
      final dateUtil = DateUtil();
      final daysInStartMonth = dateUtil.daysInMonth(weekStart.month, weekStart.year);

      int diffDay;
      DateTime diffDate;
      if (day <= daysInStartMonth) {
        diffDay = day;
        diffDate = DateTime(weekStart.year, weekStart.month, diffDay);
      } else {
        int diff = daysInStartMonth - day;
        diffDay = diff.abs();
        diffDate = DateTime(weekEnd.year, weekEnd.month, diffDay);
      }

      final dayEntries = thisWeekEntries.where((Food food) => food.dateTime.day == diffDay).toList();
      final daySodium = dayEntries.fold(0, (int accumulate, Food food) => accumulate + food.totalSodium);

      final achieved = daySodium < viewModel.user.sodiumLimit && daySodium != 0;
      final formatter = DateFormat('EE');
      final dayName = formatter.format(diffDate);

      trophies.add(
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Trophy(
            achieved: achieved,
            day: '${dayName[0]}',
            today: diffDay == now.day,
            date: diffDay,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: trophies,
    );
  }
}

class Trophy extends StatelessWidget {
  final bool achieved;
  final String day;
  final bool today;
  final int date;

  Trophy({
    this.day = 'ว',
    this.achieved = false,
    this.today = false,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(day, style: tileSubtitle),
        Icon(FontAwesomeIcons.trophy, color: achieved ? Colors.yellow : Colors.grey.shade300),
        SizedBox(height: 4.0),
        Text(today ? 'วันนี้' : '', style: tileSubtitle),
      ],
    );
  }
}

class WeekTrophyViewModel {
  final List<Food> entries;
  final User user;

  WeekTrophyViewModel({
    @required this.entries,
    @required this.user,
  });

  static WeekTrophyViewModel fromStore(Store<AppState> store) {
    return WeekTrophyViewModel(
      entries: store.state.entries,
      user: store.state.user,
    );
  }
}
