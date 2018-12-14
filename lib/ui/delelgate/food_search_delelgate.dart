import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/food/food_tile.dart';
import 'package:sodium/ui/common/loading/loading.dart';
import 'package:sodium/ui/common/loading/loading_container.dart';
import 'package:sodium/ui/screen/entry_add/container.dart';

class FoodSearchDelegate extends SearchDelegate<Food> {
  final Sink<String> search;
  final Stream<List<Food>> suggestions;
  final Stream<LoadingStatus> loadingStatus;

  FoodSearchDelegate({
    @required this.search,
    @required this.suggestions,
    @required this.loadingStatus,
  });

  void _showFoodDetail(Food food, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodAddContainer(food: food)));
  }

  void _onFoodPressed(Food food, BuildContext context) {
    _showFoodDetail(food, context);
  }

  Widget _buildFoodSuggestion(LoadingStatus loadingStatus) {
    return StreamBuilder<List<Food>>(
      stream: suggestions,
      initialData: [],
      builder: (context, snapshot) {
        final foods = snapshot.data;

        return LoadingContainer(
          loadingStatus: loadingStatus,
          loadingContent: Loading(title: 'กำลังค้นหา'),
          successContent: _buildFoodList(foods),
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    search.add(query);

    return StreamBuilder<LoadingStatus>(
      stream: loadingStatus,
      initialData: LoadingStatus.initial,
      builder: ((context, snapshot) {
        return _buildFoodSuggestion(snapshot.data);
      }),
    );
  }
}
