import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/inkwell_container.dart';

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
            style: tileTitle,
            overflow: TextOverflow.ellipsis,
          ),
          search
              ? Text(
                  '${food.type}',
                  style: tileSubtitle,
                  textAlign: TextAlign.right,
                )
              : Text(
                  '${food.serving} หน่วย',
                  style: tileSubtitle,
                  textAlign: TextAlign.right,
                ),
        ],
      ),
    );

    final trailing = Expanded(
      flex: 4,
      child: Text(
        '${search ? food.sodium : food.totalSodium} มก.',
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
