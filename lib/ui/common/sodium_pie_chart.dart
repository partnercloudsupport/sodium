import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class SodiumPieChart extends StatelessWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedCircularChart(
      duration: Duration(seconds: 0),
      key: _chartKey,
      size: const Size(100.0, 100.0),
      initialChartData: <CircularStackEntry>[
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(
              33.33,
              Theme.of(context).primaryColor,
              rankKey: 'completed',
            ),
            CircularSegmentEntry(
              66.67,
              Colors.grey,
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      percentageValues: true,
      holeLabel: '75%',
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );
  }
}
