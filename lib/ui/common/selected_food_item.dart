import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/inkwell_container.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final Function onLongPressed;
  final Function onPressed;

  FoodTile({
    this.food,
    this.onLongPressed,
    this.onPressed,
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
            style: tileTitle,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${food.type}',
            style: tileSubtitle,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );

    final trailing = Expanded(
      flex: 4,
      child: Text(
        '${food.sodium} มก.',
        style: tileTrailing,
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

    return InkWellContainer(
      onLongPressed: onLongPressed,
      onPressed: onPressed,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      highlightColor: Colors.white70,
      child: body,
    );
  }
}
