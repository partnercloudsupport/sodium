import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/food/food_action.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/food/food_tile.dart';
import 'package:sodium/ui/common/loading/loading.dart';
import 'package:sodium/ui/common/loading/loading_container.dart';
import 'package:sodium/ui/screen/entry_add/container.dart';
import 'package:sodium/ui/screen/food_user_add/screen.dart';

class UserFoodScreen extends StatefulWidget {
  final MyFoodScreenViewModel viewModel;
  final Function(Food food) onFoodClick;

  UserFoodScreen({
    this.viewModel,
    this.onFoodClick,
  });

  @override
  _UserFoodScreenState createState() => _UserFoodScreenState();
}

class _UserFoodScreenState extends State<UserFoodScreen> {
  void _showMyFoodAddScreen() {
    Navigator.of(context).pushNamed(MyFoodAddScreen.route);
  }

  void _showFoodDetail(Food food, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FoodAddContainer(
            food: food,
            dateTime: DateTime.now(),
          ),
    ));
  }

  Widget _buildFoodList(List<Food> foods) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: foods == null ? 0 : foods.length,
      itemBuilder: (BuildContext context, int index) {
        final food = foods[index];

        return Padding(
          padding: index == 0 || index == foods.length ? EdgeInsets.only(top: 8.0, left: 16, right: 16.0) : EdgeInsets.symmetric(horizontal: 16.0),
          child: FoodTile(
            food: food,
            onPressed: () => widget.onFoodClick(food),
          ),
        );
      },
    );
  }

  Widget _buildUserFoods() {
    return LoadingContainer(
      loadingStatus: LoadingStatus.success,
      loadingContent: Loading(title: 'กำลังค้นหา'),
      successContent: widget.viewModel.foods.isNotEmpty
          ? _buildFoodList(widget.viewModel.foods)
          : IconMessage(
              icon: Icon(FontAwesomeIcons.utensils, size: 64.0),
              title: Text(
                'คุณยังไม่ได้เพิ่มข้อมูลอาหารของฉัน',
                style: Style.title,
              ),
              description: Text(
                'กดปุ่มด้านล่างเพื่อเพิ่ม',
                style: Style.description,
              ),
            ),
      initialContent: IconMessage(
        icon: Icon(FontAwesomeIcons.search, size: 64.0),
        title: Text(
          'ค้าหาอาหารที่ต้องการ',
          style: TextStyle(fontSize: 20.0),
        ),
        description: Text(
          'ป้อนคำค้นหาที่ช่องด่านบน',
          style: Style.description,
        ),
      ),
      notFoundContent: IconMessage(
        icon: Icon(
          FontAwesomeIcons.meh,
          size: 64.0,
        ),
        title: Text(
          'ไม่พบอาหารที่ค้นหา',
          style: TextStyle(fontSize: 20.0),
        ),
        description: Text(
          'กรุณาลองค้นหาด้วยคำอื่น',
          style: Style.description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.add),
        label: Text('เพิ่มอาหารของฉัน'),
        onPressed: () => _showMyFoodAddScreen(),
      ),
      body: _buildUserFoods(),
    );
  }
}

class MyFoodScreenViewModel {
  final List<Food> foods;
  final Function(Food food, Completer<Null> completer) onSave;

  MyFoodScreenViewModel({
    @required this.foods,
    @required this.onSave,
  });

  static MyFoodScreenViewModel fromStore(Store<AppState> store) {
    return MyFoodScreenViewModel(
      foods: store.state.userFoods,
      onSave: (Food food, Completer<Null> completer) => store.dispatch(CreateFoodUser(food, completer)),
    );
  }
}
