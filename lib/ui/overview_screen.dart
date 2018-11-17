import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/bloc/food_bloc.dart';
import 'package:sodium/bloc/overview/overview_bloc.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/loading/shimmer.dart';
import 'package:sodium/ui/common/section_divider.dart';
import 'package:sodium/ui/common/selected_food_item.dart';
import 'package:sodium/ui/common/sodium_pie_chart.dart';
import 'package:sodium/ui/common/trophy_stats.dart';
import 'package:sodium/ui/food_search.dart';

class OverviewScreen extends StatefulWidget {
  static final String route = '/overview';

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  FoodBloc _foodBloc;
  OverviewBloc _overviewBloc;

  ScrollController _scrollController;
  bool _showFab;

  _showFoodSearch(FoodBloc overviewBloc) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FoodSearchScreen()));
  }

  Widget _buildUpperSection(List<Food> foods) {
    final totalSodium = foods.fold(0, (accumulated, food) => food.sodium + accumulated);
    final eaten = double.parse((totalSodium / 3000).toString()) * 100;
    final remaining = 100 - eaten;

    final detail = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ปริมาณโซเดียมที่ได้รับวันนี้',
          style: TextStyle(fontSize: 16.0),
        ),
        Text(
          '$totalSodium มก.',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          'ควรรับประทานไม่เกิน 2400 มก. ต่อวัน',
          style: TextStyle(fontSize: 14.0),
        ),
      ],
    );

    final pieChart = SodiumPieChart(
      eaten: eaten,
      remain: remaining,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          detail,
          pieChart,
        ],
      ),
    );
  }

  List<Widget> _buildFoodItem(BuildContext context, List<Food> foods) {
    return foods
        .map(
          (Food food) => FoodTile(food: food),
        )
        .toList();
  }

  Widget _buildFoodsSection(List<Food> foods) {
    final totalSodium = foods.fold(0, (accumulated, food) => food.sodium + accumulated);

    final header = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'รายการอาหาร',
            style: title,
          ),
          Text(
            '$totalSodium',
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

    if (foods.isNotEmpty) {
      final emptyContent = Column(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.utensils,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.0),
          Text(
            'คุณยังไม่ได้เพิ่มรายการอาหาร',
            style: description,
          ),
        ],
      );

      foodContent.add(emptyContent);
    }

    return Container(
      child: Column(
        children: foodContent,
      ),
    );
  }

  Widget _buildTrophySection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            '7 วันที่ผ่านมา',
            style: title,
          ),
          Text(
            'คุณสามรถรักษาระดับน้ำตาลได้ 5 วัน',
            style: description,
          ),
          SizedBox(height: 16.0),
          TrophyStats(),
        ],
      ),
    );
  }

  @override
  void initState() {
    _showFab = true;

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(
        () => _showFab = _scrollController.position.userScrollDirection == ScrollDirection.forward,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showFab
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
              onPressed: () => _showFoodSearch(_foodBloc),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            snap: true,
            floating: true,
            title: Text('กิจกรรมวันนี้'),
            elevation: 2.5,
            // backgroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                StreamBuilder<List<Food>>(
                  stream: _overviewBloc.outTodayEntry,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ShimmerLoading.header();
                    }

                    return _buildUpperSection(snapshot.data);
                  },
                ),
                SectionDivider(),
                StreamBuilder<List<Food>>(
                  stream: _overviewBloc.outTodayEntry,
                  builder: ((BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return ShimmerLoading.list();
                    }

                    return _buildFoodsSection(snapshot.data);
                  }),
                ),
                SectionDivider(),
                _buildTrophySection(),
                SectionDivider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
