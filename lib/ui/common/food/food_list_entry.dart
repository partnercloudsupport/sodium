import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/food/food_tile.dart';
import 'package:sodium/ui/common/section/section_divider.dart';
import 'package:sodium/utils/date_time_util.dart';

class FoodListEntry extends StatelessWidget {
  final List<Food> foods;
  final DateTime datetime;
  final bool achieved;
  final Function(Food food) onLongPressed;

  FoodListEntry({
    @required this.foods,
    @required this.datetime,
    this.achieved = false,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    final totalSodium = foods.fold(0, (accumulated, food) => food.totalSodium + accumulated);

    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(toHumanReadableDate(datetime), style: Style.title),
            SizedBox(width: 8.0),
            Icon(
              FontAwesomeIcons.medal,
              color: achieved ? Colors.yellow : Colors.grey.shade200,
              size: 20.0,
            ),
          ],
        ),
        Text('$totalSodium มก.', style: Style.descriptionPrimary),
      ],
    );

    final body = Expanded(
      child: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
              onLongPress: () => onLongPressed(foods[index]),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: FoodTile.selected(food: foods[index]),
              ),
            ),
      ),
    );

    final bottom = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          color: Colors.grey,
          icon: Icon(Icons.edit),
          onPressed: () => print('edit'),
        ),
      ],
    );

    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          SizedBox(height: 12.0),
          body,
          SectionDivider(),
          bottom,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.3,
        title: header,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: content,
    );
  }
}
