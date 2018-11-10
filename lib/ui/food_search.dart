import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/bloc/application_bloc.dart';
import 'package:sodium/bloc/bloc_provider.dart';
import 'package:sodium/bloc/overview_bloc.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/selected_food_item.dart';

class FoodSearchScreen extends StatefulWidget {
  static final String route = '/food_search';

  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<Widget> _buildFoodItem(BuildContext context, List<Food> foods) {
    return foods
        .map(
          (Food food) => SelectedFoodItem(
                food: food,
//        onLongPressed: () => _showConfirmDelete(food),
//        onPressed: () => _showSelectedFoodEditing(food),
              ),
        )
        .toList();
  }

  Widget _buildFoodsSection(List<Food> foods) {
    final header = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'รายการอาหาร',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          Text(
            foods.fold(0.0, (accumulated, food) => food.sodium + accumulated).toStringAsFixed(2),
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0),
          )
        ],
      ),
    );

    final foodContent = [
      header,
      SizedBox(height: 8.0),
    ];

    final foodItems = _buildFoodItem(context, foods);
    foodContent.addAll(foodItems);

    if (foods.isEmpty) {
      foodContent.add(Column(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.utensils,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.0),
          Text(
            'คุณยังไม่ได้เพิ่มรายการอาหาร',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ));
    }

    return Container(
      child: Column(
        children: foodContent,
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    OverviewBloc overviewBloc = BlocProvider.of<OverviewBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหาอาหาร'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'อาหารไทย'),
            Tab(text: 'อาหารทั่วไป'),
            Tab(text: 'อาหารปรุงเอง'),
          ],
        ),
      ),
//      body: StreamBuilder<User>(
//        stream: applicationBloc.outUser,
//        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
//          return Text(snapshot.data.name);
//        },
//      ),
      body: StreamBuilder<List<Food>>(
        stream: overviewBloc.outFoods,
        initialData: [],
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          return _buildFoodsSection(snapshot.data);
        }),
      ),
    );
  }
}
