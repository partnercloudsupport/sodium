import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/shimmer_content.dart';
import 'package:sodium/utils/date_time_util.dart';

class WeekTrophy extends StatelessWidget {
  final WeekTrophyViewModel viewModel;

  WeekTrophy({this.viewModel});

  Widget _buildLoading() {
    final circleShimmer = ShimmerContent(
      type: ShimmerContentType.circle,
      width: 32,
      height: 32,
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ShimmerContent(type: ShimmerContentType.title),
        SizedBox(height: 4.0),
        ShimmerContent(type: ShimmerContentType.description),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            circleShimmer,
            circleShimmer,
            circleShimmer,
            circleShimmer,
            circleShimmer,
            circleShimmer,
            circleShimmer,
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return _buildLoading();
    }

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = now.add(Duration(days: 7 - now.weekday));
    final range = weekEnd.difference(weekStart).inDays;

    int totalTrophy = 0;

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

      if (achieved) {
        totalTrophy++;
      }

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ภาพรวมสัปดาห์นี้',
              style: Style.title,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'คุณสามารถรักษาระดับน้ำตาลได้ ',
                  style: Style.description,
                ),
                Text(
                  '$totalTrophy',
                  style: Style.titlePrimary,
                ),
                Text(
                  ' วัน',
                  style: Style.description,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: trophies,
        ),
      ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(day, style: Style.tileSubtitle),
            Icon(FontAwesomeIcons.trophy, color: achieved ? Colors.yellow : Colors.grey.shade300),
            SizedBox(height: 4.0),
            Text(today ? 'วันนี้' : '', style: Style.tileSubtitle),
          ],
        )
      ],
    );
  }
}

class WeekTrophyViewModel {
  final List<Food> entries;
  final User user;
  final bool isLoading;

  WeekTrophyViewModel({
    @required this.entries,
    @required this.user,
    @required this.isLoading,
  });

  static WeekTrophyViewModel fromStore(Store<AppState> store) {
    return WeekTrophyViewModel(
      entries: store.state.entries,
      user: store.state.user,
      isLoading: store.state.entries == null || store.state.user == null,
    );
  }
}
