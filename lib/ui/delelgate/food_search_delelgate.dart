import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading_status.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/loading/loading_content.dart';
import 'package:sodium/ui/common/loading/loading_view.dart';
import 'package:sodium/ui/common/selected_food_item.dart';
import 'package:sodium/ui/food_add.dart';

class FoodSearchDelegate extends SearchDelegate<Food> {
  final Stream<List<Food>> foods;
  final Sink<String> foodsSearch;
  final Stream<LoadingStatus> foodsSearchLoading;
  final Sink<Food> foodDetailSearch;

  FoodSearchDelegate({
    @required this.foods,
    @required this.foodsSearch,
    @required this.foodsSearchLoading,
    @required this.foodDetailSearch,
  });

  void _showFoodDetail(Food food, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodAddScreen(food: food)));
  }

  void _onFoodPressed(Food food, BuildContext context) {
    if (!food.isLocal) {
      foodDetailSearch.add(food);
    }

    _showFoodDetail(food, context);
  }

  Widget _buildSuggestion(LoadingStatus loadingStatus) {
    return StreamBuilder<List<Food>>(
      stream: foods,
      initialData: [],
      builder: (context, snapshot) {
        final foods = snapshot.data;

        return LoadingView(
          loadingStatus: loadingStatus,
          loadingContent: LoadingContent(title: 'กำลังค้นหา'),
          successContent: _buildFoodList(foods),
          initialContent: IconMessage(
            icon: FontAwesomeIcons.search,
            title: 'ค้นหาอาหาร',
            description: 'ป้อนคำค้นหาที่ช่องด่านบน',
          ),
          notFoundContent: IconMessage(
            icon: FontAwesomeIcons.meh,
            title: 'ไม่พบข้อมูลในรายการอาหาร',
            description: 'กรุณาลองค้นหาด้วยคำอื่น',
          ),
        );
      },
    );
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
            onPressed: () => _onFoodPressed(food, context),
          ),
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Food>>(
      stream: foods,
      initialData: [],
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        final foods = snapshot.data;

        return _buildFoodList(foods);
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    foodsSearch.add(query);

    return StreamBuilder<LoadingStatus>(
      stream: foodsSearchLoading,
      initialData: LoadingStatus.initial,
      builder: ((context, snapshot) {
        final loadingStatus = snapshot.data;

        return _buildSuggestion(loadingStatus);
      }),
    );
  }
}
