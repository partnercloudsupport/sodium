import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class SodiumPieChart extends StatelessWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey = GlobalKey<AnimatedCircularChartState>();

  final double eaten;
  final double remain;

  SodiumPieChart({
    @required this.eaten,
    @required this.remain,
  });

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
              eaten,
              Theme.of(context).primaryColor,
              rankKey: 'completed',
            ),
            CircularSegmentEntry(
              remain,
              Colors.grey.shade400,
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      percentageValues: true,
      holeLabel: '${eaten.toInt()}%',
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }
}
