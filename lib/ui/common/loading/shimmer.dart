import 'package:flutter/material.dart';
import 'package:sodium/utils/widget_utils.dart';

class ShimmerLoading extends StatelessWidget {
  final ShimmerType type;

  ShimmerLoading.header({
    this.type = ShimmerType.header,
  });

  ShimmerLoading.list({
    this.type = ShimmerType.list,
  });

  Widget _buildHeaderShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              shimmer(190, 20),
              SizedBox(height: 16.0),
              shimmer(130, 15),
              SizedBox(height: 16.0),
              shimmer(150, 10),
            ],
          ),
          shimmer(80, 80),
        ],
      ),
    );
  }

  Widget _buildListShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              shimmer(130, 15),
              shimmer(30, 15),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              shimmer(90, 15),
              shimmer(30, 15),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              shimmer(145, 15),
              shimmer(30, 15),
            ],
          ),
        ],
      ),
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

    return _buildHeaderShimmer();
  }
}

enum ShimmerType {
  header,
  list,
}
