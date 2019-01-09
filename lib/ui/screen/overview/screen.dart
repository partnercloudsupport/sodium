import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/food/food_selector.dart';
import 'package:sodium/ui/common/Icon_message.dart';
import 'package:sodium/ui/common/chart/sodium_pie_chart.dart';
import 'package:sodium/ui/common/food/food_action/food_action_options_container.dart';
import 'package:sodium/ui/common/food/food_tile.dart';
import 'package:sodium/ui/common/loading/loading_shimmer.dart';
import 'package:sodium/ui/common/section/section_divider.dart';
import 'package:sodium/ui/common/week_trophy/week_trophy_container.dart';
import 'package:sodium/ui/screen/food_search/screen.dart';

class OverviewScreen extends StatefulWidget {
  static final String route = '/overview';

  final OverviewScreenViewModel viewModel;

  OverviewScreen({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  _showFoodSearch() {
    Navigator.of(context).pushNamed(FoodSearchScreen.route);
  }

  void _showFoodActions(Food food) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext modalBottomSheetContext) => FoodActionOptionContainer(
            food: food,
            parentContext: context,
          ),
    );
  }

  Widget _buildUpperSection(List<Food> foods) {
    final totalSodium = foods.fold(0, (accumulated, food) => food.totalSodium + accumulated);
    final eaten = double.parse((totalSodium / widget.viewModel.user.sodiumLimit).toString()) * 100;
    final remaining = 100 - eaten;

    final detail = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ปริมาณโซเดียมที่ได้รับวันนี้',
          style: Style.title,
        ),
        Text(
          '$totalSodium มก.',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Row(
          children: <Widget>[
            Text(
              'ควรรับประทานไม่เกิน',
              style: Style.description,
            ),
            SizedBox(width: 4.0),
            Text(
              '${widget.viewModel.user.sodiumLimit}',
              style: Style.titlePrimary,
            ),
            SizedBox(width: 2.0),
            Text(
              ' มก. ต่อวัน',
              style: Style.description,
            ),
          ],
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
          Expanded(flex: 7, child: detail),
          Expanded(flex: 2, child: pieChart),
        ],
      ),
    );
  }

  Widget _buildUpperSectionLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: ShimmerLoading.header(),
    );
  }

  List<Widget> _buildFoodItem(BuildContext context, List<Food> foods) {
    return foods
        .map(
          (Food food) => Padding(
                padding: EdgeInsets.only(left: 8.0, right: 12.0),
                child: FoodTile.selected(
                  food: food,
                  padding: EdgeInsets.only(bottom: 8.0),
                  onLongPressed: () => _showFoodActions(food),
                ),
              ),
        )
        .toList();
  }

  Widget _buildFoodsSection(List<Food> foods) {
    final header = Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'อาหารที่บริโภควันนี้',
            style: Style.title,
          ),
          FlatButton(
            onPressed: () => _showFoodSearch(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add, color: Theme.of(context).primaryColor),
                SizedBox(width: 4.0),
                Text('เพิ่มบันทึกอาหาร', style: TextStyle(color: Theme.of(context).primaryColor)),
              ],
            ),
          )
        ],
      ),
    );

    final foodContent = [
      header,
      SizedBox(height: 8.0),
    ];

    final foodItems = _buildFoodItem(context, foods.reversed.toList());
    foodContent.addAll(foodItems);

    if (foods.isEmpty) {
      final emptyMessage = IconMessage(
        title: Text(
          'คุณยังไมได้เพิ่มบันทึกอาหาร',
          style: Style.description,
        ),
        icon: Icon(
          FontAwesomeIcons.utensils,
          color: Colors.grey,
        ),
      );

      foodContent.add(emptyMessage);
    }

    return Column(
      children: foodContent,
    );
  }

  Widget _buildFoodSectionLoading() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: ShimmerLoading.list(),
    );
  }

  Widget _buildTrophySection() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: TrophyWeekContainer(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                widget.viewModel.isLoading ? _buildUpperSectionLoading() : _buildUpperSection(widget.viewModel.entries),
                SectionDivider(),
                _buildTrophySection(),
                SectionDivider(),
                widget.viewModel.isLoading ? _buildFoodSectionLoading() : _buildFoodsSection(widget.viewModel.entries),
                SectionDivider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OverviewScreenViewModel {
  final List<Food> entries;
  final User user;
  final bool isLoading;

  OverviewScreenViewModel({
    @required this.entries,
    @required this.user,
    @required this.isLoading,
  });

  static OverviewScreenViewModel fromStore(Store<AppState> store) {
    return OverviewScreenViewModel(
      entries: todayEntriesSelector(store.state.entries),
      user: store.state.user,
      isLoading: store.state.user == null || store.state.entries == null,
    );
  }
}
