import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/ripple.dart';
import 'package:sodium/utils/string_util.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final Function onLongPressed;
  final Function onPressed;
  final bool search;

  FoodTile({
    this.food,
    this.onLongPressed,
    this.onPressed,
    this.search = true,
  });

  FoodTile.selected({
    this.food,
    this.onLongPressed,
    this.onPressed,
    this.search = false,
  });

  @override
  Widget build(BuildContext context) {
    final heading = Expanded(
      flex: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${food.name}',
            style: Style.tileTitle,
            overflow: TextOverflow.ellipsis,
          ),
          search
              ? Text(
                  '${food.type}',
                  style: Style.tileSubtitle,
                  textAlign: TextAlign.right,
                )
              : Text(
                  '${decimalToFraction(food.serving)} ${food.unit}',
                  style: Style.tileSubtitle,
                  textAlign: TextAlign.right,
                ),
        ],
      ),
    );

    final trailing = Expanded(
      flex: 4,
      child: Text(
        '${search ? food.sodium : food.totalSodium} มก',
        style: Style.tileTrailing,
        textAlign: TextAlign.right,
      ),
    );

    final body = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        heading,
        food.isLocal ? trailing : Container(),
      ],
    );

    return RippleContainer(
      onLongPressed: onLongPressed,
      onPressed: onPressed,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      highlightColor: Colors.white70,
      child: body,
    );
  }
}
