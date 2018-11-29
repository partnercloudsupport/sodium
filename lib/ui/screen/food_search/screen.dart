import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/food/food_action.dart';
import 'package:sodium/redux/ui/food_search/food_search_state.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/delelgate/food_search_delelgate.dart';

class FoodSearchScreen extends StatefulWidget {
  static final String route = '/food_search';

  final FoodSearchScreenViewModel viewModel;

  FoodSearchScreen({this.viewModel});

  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  BehaviorSubject<String> _foodSearchController = BehaviorSubject();
  BehaviorSubject<List<Food>> _foods = BehaviorSubject();
  BehaviorSubject<LoadingStatus> _loadingStatus = BehaviorSubject();

  String latestQuery = '';

  void _showSearch() {
    final FoodSearchDelegate foodSearchDelegate = FoodSearchDelegate(
      search: _foodSearchController.sink,
      suggestions: _foods.stream,
      loadingStatus: _loadingStatus.stream,
    );

    showSearch(
      context: context,
      delegate: foodSearchDelegate,
    );
  }

  Widget _buildContent(LoadingStatus loadingStatus) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconMessage(
          icon: Icon(FontAwesomeIcons.search, size: 64.0),
          title: Text(
            'ค้นหาอาหารที่ต้องการ',
            style: title,
          ),
          description: Text(
            'กดปุ่มด้านล่างเพื่อค้นหา',
            style: description,
          ),
        ),
        SizedBox(height: 32.0),
        FlatButton(
          onPressed: _showSearch,
          child: Text('ค้นหา', style: TextStyle(color: Colors.white)),
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 48.0),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _foodSearchController.debounce(Duration(milliseconds: 500)).listen((String query) {
      if (query.isNotEmpty && query != latestQuery) {
        widget.viewModel.onSearch(query);
      }

      setState(() {
        latestQuery = query;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _foodSearchController.close();
    _foods.close();
    _loadingStatus.close();
  }

  @override
  Widget build(BuildContext context) {
    _foods.add(widget.viewModel.foods);
    _loadingStatus.add(widget.viewModel.state.loadingStatus);

    return Scaffold(
      appBar: AppBar(
        elevation: .75,
        title: Text('ค้นหาอาหาร'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearch(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'อาหารทั่วไป'),
            Tab(text: 'อาหารของฉัน'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContent(widget.viewModel.state.loadingStatus),
        ],
      ),
    );
  }
}

class FoodSearchScreenViewModel {
  final FoodSearchState state;
  final List<Food> foods;
  final Function(String query) onSearch;

  FoodSearchScreenViewModel({
    @required this.state,
    @required this.foods,
    @required this.onSearch,
  });

  static FoodSearchScreenViewModel fromStore(Store<AppState> store) {
    return FoodSearchScreenViewModel(
      state: store.state.uiState.foodSearchState,
      foods: store.state.foodSearchResults,
      onSearch: (String query) => store.dispatch(SearchFood(query)),
    );
  }
}