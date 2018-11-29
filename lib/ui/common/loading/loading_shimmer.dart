import 'package:clippy_flutter/polygon.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/common/shimmer_content.dart';

class ShimmerLoading extends StatelessWidget {
  final ShimmerType type;

  ShimmerLoading.header({this.type = ShimmerType.header});

  ShimmerLoading.list({this.type = ShimmerType.list});

  ShimmerLoading.calendar({this.type = ShimmerType.calendar});

  ShimmerLoading.navigationHeader({this.type = ShimmerType.navigationHeader});

  ShimmerLoading.chart({this.type = ShimmerType.chart});

  ShimmerLoading.achievementList({this.type = ShimmerType.achievementList});

  ShimmerLoading.circle({this.type = ShimmerType.circle});

  Widget _buildHeaderShimmer() {
    final leftContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ShimmerContent(
          type: ShimmerContentType.title,
        ),
        SizedBox(height: 16.0),
        ShimmerContent(
          type: ShimmerContentType.description,
        ),
        SizedBox(height: 8.0),
        ShimmerContent(
          type: ShimmerContentType.description,
          width: 80,
        ),
        SizedBox(height: 8.0),
        ShimmerContent(
          type: ShimmerContentType.description,
          width: 30,
        ),
        SizedBox(height: 8.0),
      ],
    );

    final rightContent = ShimmerContent(
      height: 80,
      width: 80,
      type: ShimmerContentType.circle,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        leftContent,
        rightContent,
      ],
    );
  }

  Widget _buildListShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ShimmerContent(type: ShimmerContentType.listTile),
        SizedBox(height: 12.0),
        ShimmerContent(type: ShimmerContentType.listTile),
        SizedBox(height: 12.0),
        ShimmerContent(type: ShimmerContentType.listTile),
      ],
    );
  }

  Widget _buildNavigationHeaderShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.chevron_left, color: Colors.blueGrey.shade300),
        ShimmerContent(type: ShimmerContentType.title),
        Icon(Icons.chevron_right, color: Colors.blueGrey.shade300),
      ],
    );
  }

  Widget _buildCalendarShimmer() {
    return Shimmer.fromColors(
      period: Duration(seconds: 3),
      baseColor: Palette.shimmer,
      highlightColor: Palette.shimmerHighlight,
      child: Container(
        color: Colors.grey,
        height: 200,
        width: double.infinity,
      ),
    );
  }

  Widget _buildChartShimmer() {
    final shimmerChart = Column(
      children: <Widget>[
        Shimmer.fromColors(
          period: Duration(seconds: 3),
          baseColor: Palette.shimmer,
          highlightColor: Palette.shimmerHighlight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(color: Colors.grey, height: 170, width: 15),
              Container(color: Colors.grey, height: 90, width: 15),
              Container(color: Colors.grey, height: 133, width: 15),
              Container(color: Colors.grey, height: 88, width: 15),
              Container(color: Colors.grey, height: 20, width: 15),
              Container(color: Colors.grey, height: 88, width: 15),
              Container(color: Colors.grey, height: 15, width: 15),
              Container(color: Colors.grey, height: 95, width: 15),
              Container(color: Colors.grey, height: 55, width: 15),
              Container(color: Colors.grey, height: 120, width: 15),
            ],
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );

    return shimmerChart;
  }

  Widget _buildAchievementListShimmer() {
    final sixSidesPolygon = Polygon(
      sides: 6,
      child: Container(
        color: Colors.grey,
        width: 70.0,
        height: 70.0,
      ),
    );

    final shimmerPolygon = Column(
      children: <Widget>[
        Shimmer.fromColors(
          baseColor: Palette.shimmer,
          highlightColor: Palette.shimmerHighlight,
          child: sixSidesPolygon,
        ),
        SizedBox(height: 8.0),
        ShimmerContent(type: ShimmerContentType.description),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ShimmerContent(type: ShimmerContentType.title),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            shimmerPolygon,
            shimmerPolygon,
            shimmerPolygon,
            shimmerPolygon,
          ],
        ),
      ],
    );
  }

  Widget _buildCirclesShimmer() {
    final circleShimmer = ShimmerContent(
      type: ShimmerContentType.circle,
      width: 40,
      height: 40,
      baseColor: Palette.shimmer,
      highlightColor: Palette.shimmerHighlight,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        circleShimmer,
        circleShimmer,
        circleShimmer,
        circleShimmer,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == ShimmerType.header) {
      return _buildHeaderShimmer();
    }

    if (type == ShimmerType.list) {
      return _buildListShimmer();
    }

    if (type == ShimmerType.calendar) {
      return _buildCalendarShimmer();
    }

    if (type == ShimmerType.navigationHeader) {
      return _buildNavigationHeaderShimmer();
    }

    if (type == ShimmerType.chart) {
      return _buildChartShimmer();
    }

    if (type == ShimmerType.achievementList) {
      return _buildAchievementListShimmer();
    }

    if (type == ShimmerType.circle) {
      return _buildCirclesShimmer();
    }

    return _buildHeaderShimmer();
  }
}

enum ShimmerType {
  header,
  list,
  calendar,
  navigationHeader,
  chart,
  sixSides,
  circle,
  achievementList,
}
