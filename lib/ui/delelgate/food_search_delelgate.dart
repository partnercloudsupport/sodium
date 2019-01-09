import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_drawer_handle/modal_drawer_handle.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/chip.dart';
import 'package:sodium/ui/common/food/food_tile.dart';
import 'package:sodium/ui/common/loading/loading.dart';
import 'package:sodium/ui/common/loading/loading_container.dart';
import 'package:sodium/utils/widget_utils.dart';

class FoodSearchDelegate extends SearchDelegate<Food> {
  final Sink<String> search;
  final Stream<List<Food>> suggestions;
  final Stream<LoadingStatus> loadingStatus;
  final Function(Food food) onFoodClick;

  FoodSearchDelegate({
    @required this.search,
    @required this.suggestions,
    @required this.loadingStatus,
    @required this.onFoodClick,
  });

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
        return Divider(height: 1.0);
      },
      itemCount: foods == null ? 0 : foods.length,
      itemBuilder: (BuildContext context, int index) {
        final food = foods[index];

        return FoodTile(
          food: food,
          onPressed: () => onFoodClick(food),
        );
      },
    );
  }

  void _showFilter(BuildContext context) {
    final handler = Padding(
      padding: EdgeInsets.all(8.0),
      child: ModalDrawerHandle(
        handleColor: Theme.of(context).primaryColor,
      ),
    );

    final header = Wrap(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('ประเภทอาหาร', style: Style.title),
          ],
        ),
      ],
    );

    final categories = ['แกง', 'ผัด', 'ต้ม', 'ข้าว'];
    final body = Wrap(
      children: categories
          .map((String category) => Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: ChipSelector(
                  label: category,
                  selected: false,
                  onTap: () {
                    query = category;
                    popDialog(context);
                  },
                ),
              ))
          .toList(),
    );

    final content = Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          handler,
          header,
          SizedBox(height: 12.0),
          body,
        ],
      ),
    );

    showRoundedModalBottomSheet(context: context, builder: (BuildContext context) => content, dismissOnTap: false);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: () => _showFilter(context),
      ),
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
