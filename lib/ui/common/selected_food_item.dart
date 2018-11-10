import 'package:flutter/material.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/inkwell_container.dart';

class SelectedFoodItem extends StatelessWidget {
  final Food food;
  final Function onLongPressed;
  final Function onPressed;

  SelectedFoodItem({
    this.food,
    this.onLongPressed,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final body = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                food.name,
                style: TextStyle(fontSize: 17.0, color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${food.getAmountText()} ${food.unit}',
                style: TextStyle(fontSize: 14.0, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '${food.totalSodium.toStringAsFixed(2)}',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey.shade500,
            ),
          ),
        )
      ],
    );

    return InkWellContainer(
      onLongPressed: onLongPressed,
      onPressed: onPressed,
      margin: EdgeInsets.only(bottom: 8.0),
      backgroundColor: Colors.grey.shade100,
      highlightColor: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
        child: body,
      ),
    );
  }
}
