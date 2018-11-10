import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/bloc/bloc_provider.dart';
import 'package:sodium/bloc/overview_bloc.dart';
import 'package:sodium/data/model/food.dart';
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
  OverviewBloc _overviewBloc;
  ScrollController _scrollController;
  bool _showFab;

  _showFoodSearch(OverviewBloc overviewBloc) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FoodSearchScreen()));
  }

  Widget _buildDetailSection() {
    final detailPart = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ปริมาณโซเดียมที่ได้รับวันนี้',
          style: TextStyle(fontSize: 16.0),
        ),
        Text(
          '1800 มก.',
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        detailPart,
      ],
    );
  }

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
      final emptyContent = Column(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.utensils,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.0),
          Text('คุณยังไม่ได้เพิ่มรายการอาหาร', style: TextStyle(color: Colors.grey)),
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

  Widget _buildUpperSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildDetailSection(),
          SodiumPieChart(),
        ],
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
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          Text(
            'คุณสามรถรักษาระดับน้ำตาลได้ 5 วัน',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          SizedBox(height: 16.0),
          TrophyStats()
        ],
      ),
    );
  }

  @override
  void initState() {
    _showFab = true;

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward)
        setState(() {
          _showFab = true;
        });
      else
        setState(() {
          _showFab = false;
        });
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
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showFab
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
              onPressed: () => _showFoodSearch(_overviewBloc),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            snap: true,
            floating: true,
            title: Text(
              'กิจกรรมวันนี้',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            elevation: .75,
            backgroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildUpperSection(),
                SectionDivider(),
                StreamBuilder<List<Food>>(
                  stream: _overviewBloc.outFoods,
                  initialData: [],
                  builder: ((BuildContext context, AsyncSnapshot snapshot) {
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
