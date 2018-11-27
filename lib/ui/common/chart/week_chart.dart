import 'package:charts_flutter/flutter.dart' as charts;
import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:sodium/data/model/food.dart';

class TimeSeriesBar extends StatelessWidget {
  final List<charts.Series<TimeSeriesEntry, DateTime>> seriesList;
  final bool animate;

  TimeSeriesBar(this.seriesList, {this.animate});

  factory TimeSeriesBar.withRealData(DateTime month, List<Food> entries) {
    return TimeSeriesBar(
      _convertData(month, entries),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      domainAxis: charts.DateTimeAxisSpec(
        usingBarRenderer: true,
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontFamily: 'Kanit', color: charts.MaterialPalette.gray.shade500),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontFamily: 'Kanit', color: charts.MaterialPalette.gray.shade500),
        ),
      ),
      defaultInteractions: false,
      behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
    );
  }

  static List<charts.Series<TimeSeriesEntry, DateTime>> _convertData(DateTime month, List<Food> entries) {
    final List<TimeSeriesEntry> series = [];
    final dateUtility = DateUtil();

    for (int day = 1; day <= dateUtility.daysInMonth(month.month, month.year); day++) {
      final dayEntries = entries.where((Food food) => food.dateTime.day == day).toList();
      final daySodium = dayEntries.fold(0, (int accumulate, Food food) => accumulate + food.totalSodium);
      final daySeries = TimeSeriesEntry(DateTime(month.year, month.month, day), daySodium);

      series.add(daySeries);
    }

    return [
      charts.Series<TimeSeriesEntry, DateTime>(
        id: 'Sales',
        colorFn: (TimeSeriesEntry sales, int color) => sales.sodium > 2400 ? charts.MaterialPalette.red.shadeDefault : charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSeriesEntry sales, _) => sales.time,
        measureFn: (TimeSeriesEntry sales, _) => sales.sodium,
        data: series,
        labelAccessorFn: (TimeSeriesEntry sales, int index) => 'test',
      ),
    ];
  }
}

class TimeSeriesEntry {
  final DateTime time;
  final int sodium;

  TimeSeriesEntry(this.time, this.sodium);

  @override
  String toString() {
    return '{time: ${time.day}, sodium: $sodium}';
  }
}
