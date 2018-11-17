import 'package:flutter/material.dart';
import 'package:sodium/bloc/food_bloc.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/ui/delelgate/food_search_delelgate.dart';

class FoodSearchScreen extends StatefulWidget {
  static final String route = '/food_search';

  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  void _showSearch(FoodBloc foodBloc) {
    final FoodSearchDelegate foodSearchDelegate = FoodSearchDelegate(
      foods: foodBloc.outFoods,
      foodsSearch: foodBloc.inSearchFood,
      foodsSearchLoading: foodBloc.outFoodSearchLoading,
      foodDetailSearch: foodBloc.inFoodDetailSearch,
    );

    showSearch(
      context: context,
      delegate: foodSearchDelegate,
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FoodBloc _foodBloc = BlocProvider.of<FoodBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: .75,
        title: Text('ค้นหาอาหาร'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearch(_foodBloc),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'อาหารแนะนำ'),
            Tab(text: 'อาหารของฉัน'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
//          StreamBuilder<List<Food>>(
//            stream: _foodBloc.outFoods,
//            initialData: [],
//            builder: ((BuildContext context, AsyncSnapshot snapshot) {
//              return _buildFoodList(snapshot.data);
//            }),
//          ),
          Text('test'),
        ],
      ),
    );
  }
}
