import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sodium/constant/styles.dart';

class ShimmerContent extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerContentType type;

  ShimmerContent({
    this.child,
    this.height,
    this.width,
    this.highlightColor,
    this.baseColor,
    this.type,
  });

  Widget _buildTitleShimmer() {
    return ShimmerContent(
      height: 15,
      width: width ?? 120.0,
      baseColor: Palette.shimmerDark,
      highlightColor: Palette.shimmerDarkHighlight,
    );
  }

  Widget _buildSubTitleShimmer() {
    return ShimmerContent(
      height: 10,
      width: width ?? 120.0,
      baseColor: Palette.shimmerDark,
      highlightColor: Palette.shimmerDarkHighlight,
    );
  }

  Widget _buildCircleShimmer() {
    final circle = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      width: width ?? 50,
      height: height ?? 50,
    );

    final shimmerCircle = Shimmer.fromColors(
      baseColor: baseColor ?? Palette.shimmerDark,
      highlightColor: highlightColor ?? Palette.shimmerDarkHighlight,
      child: circle,
    );

    return shimmerCircle;
  }

  Widget _buildDescription() {
    return ShimmerContent(
      height: height ?? 8.0,
      width: width ?? 50.0,
      baseColor: baseColor ?? Palette.shimmer,
      highlightColor: highlightColor ?? Palette.shimmerHighlight,
    );
  }

  Widget _buildImage() {
    return ShimmerContent(
      height: height ?? 80.0,
      width: width ?? 80.0,
      baseColor: baseColor ?? Palette.shimmerDark,
      highlightColor: highlightColor ?? Palette.shimmerDarkHighlight,
    );
  }

  Widget _buildListTile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSubTitleShimmer(),
            SizedBox(height: 2.0),
            _buildDescription(),
          ],
        ),
        _buildDescription(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == ShimmerContentType.title) {
      return _buildTitleShimmer();
    }

    if (type == ShimmerContentType.subtitle) {
      return _buildSubTitleShimmer();
    }

    if (type == ShimmerContentType.description) {
      return _buildDescription();
    }

    if (type == ShimmerContentType.circle) {
      return _buildCircleShimmer();
    }

    if (type == ShimmerContentType.image) {
      return _buildImage();
    }

    if (type == ShimmerContentType.listTile) {
      return _buildListTile();
    }

    return Shimmer.fromColors(
      period: Duration(seconds: 3),
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child != null
          ? child
          : Container(
              color: baseColor,
              height: height,
              width: width,
            ),
    );
  }
}

enum ShimmerContentType {
  title,
  subtitle,
  description,
  circle,
  image,
  listTile,
}
