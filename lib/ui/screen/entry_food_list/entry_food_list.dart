import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/food/food_action/food_action_options_container.dart';
import 'package:sodium/ui/common/food/food_tile.dart';
import 'package:sodium/ui/screen/food_search/container.dart';
import 'package:sodium/utils/date_time_util.dart';

class EntryFoodList extends StatelessWidget {
  final EntryFoodListViewModel viewModel;
  final DateTime datetime;

  EntryFoodList({
    @required this.datetime,
    this.viewModel,
  });

  void _showFoodSearch(BuildContext context, DateTime datetime) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => FoodSearchContainer(dateTime: datetime)),
    );
  }

  void _showActions(Food food, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalBottomSheetContext) => FoodActionOptionContainer(
            food: food,
            parentContext: context,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thisDayEntries = viewModel.entries.where((Food food) => isSameDate(food.dateTime, datetime)).toList();
    final totalSodium = thisDayEntries.fold(0, (accumulated, food) => food.totalSodium + accumulated);
    final achieved = totalSodium < viewModel.user.sodiumLimit && totalSodium != 0;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.3,
        title: header,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Column(
        children: <Widget>[
          thisDayEntries.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: thisDayEntries.length,
                    itemBuilder: (BuildContext context, int index) => GestureDetector(
                          onLongPress: () => _showActions(thisDayEntries[index], context),
                          child: FoodTile.selected(
                            padding: EdgeInsets.all(8.0),
                            food: thisDayEntries[index],
                          ),
                        ),
                  ),
                )
              : Expanded(
                  child: IconMessage(
                    icon: Icon(FontAwesomeIcons.stroopwafel, size: 64.0),
                    title: Text(
                      'คุณยังไม่ได้เพิ่มบันทึกอาหารสำหรับวันนี้',
                      style: Style.title,
                    ),
                    description: Text(
                      'กดปุ่มด้านล่างเพื่อเพิ่ม',
                      style: Style.description,
                    ),
                  ),
                ),
          FlatButton(
            onPressed: () => _showFoodSearch(context, datetime),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add, color: Theme.of(context).primaryColor),
                SizedBox(width: 4.0),
                Text('เพิ่มบันทึกอาหาร', style: TextStyle(color: Theme.of(context).primaryColor)),
              ],
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class EntryFoodListViewModel {
  final List<Food> entries;
  final User user;

  EntryFoodListViewModel({
    @required this.entries,
    @required this.user,
  });

  static EntryFoodListViewModel fromStore(Store<AppState> store) {
    return EntryFoodListViewModel(
      entries: store.state.entries,
      user: store.state.user,
    );
  }
}
