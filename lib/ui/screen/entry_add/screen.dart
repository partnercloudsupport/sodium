import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/entry/entry_action.dart';
import 'package:sodium/redux/food/food_selector.dart';
import 'package:sodium/redux/ui/food_add/food_add_state.dart';
import 'package:sodium/ui/common/info_item.dart';
import 'package:sodium/ui/common/loading/loading.dart';
import 'package:sodium/ui/common/loading/loading_container.dart';
import 'package:sodium/ui/common/number_bar.dart';
import 'package:sodium/ui/common/ripple.dart';
import 'package:sodium/ui/common/section/section.dart';
import 'package:sodium/ui/common/section/section_divider.dart';
import 'package:sodium/ui/seasoning_section/seasoning_container.dart';
import 'package:sodium/utils/completers.dart';
import 'package:sodium/utils/date_time_util.dart';

class AddEntryScreen extends StatefulWidget {
  static final String route = '/food_detail';

  final Food food;
  final bool editing;
  final FoodAddScreenViewModel viewModel;
  final DateTime dateTime;

  AddEntryScreen({
    @required this.food,
    @required this.viewModel,
    @required this.dateTime,
    this.editing = false,
  });

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  double _serving = 1;
  List<Seasoning> _selectedSeasonings;
  int _selectedSeasoningTotalSodium;
  DateTime _dateTime;

  double get totalSodiumWithSeasoning => ((widget.food.isLocal ? widget.food.sodium.toDouble() : widget.viewModel.foodSearchSelected.sodium.toDouble()) * _serving) + _selectedSeasoningTotalSodium;

  void _showDatePicker() {
    final now = DateTime.now();

    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      locale: 'en',
      minYear: 1970,
      maxYear: now.year + 1,
      initialYear: now.year,
      initialMonth: now.month,
      initialDate: now.day,
      cancel: Text('ยกเลิก', style: Style.description),
      confirm: Text('บันทึก', style: Style.descriptionPrimary),
      dateFormat: 'dd-mmmm-yyyy',
      onConfirm: (year, month, date) {
        setState(() {
          _dateTime = DateTime(year, month, date);
        });
      },
    );
  }

  void _showCalculationInfo(int entrySodium, int totalSodium) {
    final content = [
      InfoItem(
        title: Text(
          'วันนี้',
          style: Style.tileTitle,
        ),
        info: Text(
          '${widget.viewModel.todayEatenSodium} มก.',
          style: Style.description,
        ),
      ),
      InfoItem(
        title: Text(
          'มื้อนี้',
          style: Style.tileTitle,
        ),
        info: Text(
          '$entrySodium มก.',
          style: Style.description,
        ),
      ),
      SectionDivider(),
      InfoItem(
        title: Text(
          'รวม',
          style: Style.tileTitle,
        ),
        info: Text(
          '$totalSodium มก.',
          style: Style.description,
        ),
      )
    ];

    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            title: Text('ข้อมูลเพิ่มเติม'),
            children: content,
          ),
    );
  }

  void _save(Food food) async {
    final _food = food.copyWith(
      serving: _serving,
      totalSodium: totalSodiumWithSeasoning.toInt(),
      seasonings: _selectedSeasonings,
      dateTime: _dateTime,
    );

    final Completer<CreateEntryResponse> completer = loadingThenPopCompleter(context, 'กำลังบันทึก..', 'บันทึกแล้ว', 'บันทึกไม่สำเร็จ');

    if (widget.editing) {
      widget.viewModel.onUpdate(_food, completer);
    } else {
      widget.viewModel.onCreate(_food, completer);
    }
  }

  Widget _buildLoadingView(LoadingStatus loadingStatus) {
    return LoadingContainer(
      loadingStatus: loadingStatus,
      loadingContent: Loading(title: 'กำลังโหลด'),
      initialContent: _buildContent(widget.viewModel.foodSearchSelected),
    );
  }

  Widget _buildContent(Food food) {
    if (food == null) {
      return Container();
    }

    final int entrySodium = (_serving * food.sodium).toInt();
    final int totalSodium = widget.viewModel.todayEatenSodium + entrySodium;
    final int remaining = widget.viewModel.user.sodiumLimit - totalSodium;
    final bool limitExcess = totalSodium > widget.viewModel.user.sodiumLimit;

    final double eatenPercent = double.parse((totalSodium / widget.viewModel.user.sodiumLimit).toString());
    final nameSection = SectionContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Text(
              '${widget.food.name}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${totalSodiumWithSeasoning.toInt()} มก.',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'วันที่',
            style: Style.description,
          ),
          GestureDetector(
            child: Text('${toHumanReadableDate(_dateTime)}', style: TextStyle(color: Theme.of(context).primaryColor)),
            onTap: () => _showDatePicker(),
          ),
        ],
      ),
    );

    final progressSection = SectionContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                remaining >= 0 ? 'บริโภคได้อีก' : 'บริโภคเกินมา',
                style: Style.title,
              ),
              SizedBox(width: 4.0),
              GestureDetector(
                onTap: () => _showCalculationInfo(entrySodium, totalSodium),
                child: Icon(Icons.info_outline, color: Colors.grey),
              ),
            ],
          ),
          Text(
            '${remaining.abs()} มก.',
            style: TextStyle(color: limitExcess ? Colors.redAccent : Theme.of(context).primaryColor, fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint) {
            return LinearPercentIndicator(
              width: constraint.maxWidth,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 500,
              percent: eatenPercent > 1.0 ? 1.0 : eatenPercent,
              center: Text("$totalSodium/${widget.viewModel.user.sodiumLimit} มก.", style: TextStyle(color: Colors.white)),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: limitExcess ? Colors.redAccent : Theme.of(context).primaryColor,
            );
          }),
        ],
      ),
    );

    final servingSection = SectionContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'เลือกจำนวนที่รับประทาน',
            style: Style.title,
          ),
          Text(
            '${food.unit}',
            style: Style.description,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          NumberBar(
            initial: _serving,
            max: 15,
            values: food.sodium,
            excessValue: widget.viewModel.user.sodiumLimit - widget.viewModel.todayEatenSodium,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey.shade300,
            onValueChange: (value) {
              setState(() => _serving = value);
            },
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'โซเดียม ',
                style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey),
                textAlign: TextAlign.right,
              ),
              Text(
                ' ${(_serving * food.sodium).toInt()} มก.',
                style: TextStyle(color: limitExcess ? Colors.redAccent : Theme.of(context).primaryColor, fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 4.0),
                  nameSection,
                  SizedBox(height: 4.0),
                  servingSection,
                  SizedBox(height: 4.0),
                  SeasoningSelectionSectionContainer(
                    onSelected: (seasonings, totalSodium) {
                      setState(() {
                        _selectedSeasonings = seasonings;
                        _selectedSeasoningTotalSodium = totalSodium;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        RippleContainer(
          backgroundColor: Theme.of(context).primaryColor,
          highlightColor: Palette.highlight,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            width: double.infinity,
            child: Text('บันทึก', style: TextStyle(color: Colors.white)),
          ),
          onPressed: () => _save(food),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _selectedSeasonings = [];
    _selectedSeasoningTotalSodium = 0;

    _dateTime = widget.dateTime ?? DateTime.now();

    if (widget.editing) {
      _dateTime = widget.food.dateTime;
      _serving = widget.food.serving;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มบันทึกอาหาร'),
        elevation: .75,
      ),
      backgroundColor: Colors.grey.shade100,
      body: widget.food.isLocal
          ? _buildContent(
              widget.food,
            )
          : _buildLoadingView(
              widget.viewModel.state.loadingStatus,
            ),
    );
  }
}

class FoodAddScreenViewModel {
  final Food foodSearchSelected;
  final User user;
  final FoodAddState state;
  final int todayEatenSodium;
  final List<Seasoning> seasonings;
  final Function(Food food, Completer<CreateEntryResponse> completer) onCreate;
  final Function(Food food, Completer<CreateEntryResponse> completer) onUpdate;

  FoodAddScreenViewModel({
    @required this.foodSearchSelected,
    @required this.user,
    @required this.todayEatenSodium,
    @required this.seasonings,
    @required this.state,
    @required this.onCreate,
    this.onUpdate,
  });

  static FoodAddScreenViewModel fromStore(Store<AppState> store) {
    return FoodAddScreenViewModel(
      foodSearchSelected: store.state.foodSearchSelected,
      user: store.state.user,
      todayEatenSodium: todayEatenSodiumSelector(store.state.entries),
      seasonings: store.state.seasonings,
      state: store.state.uiState.foodAddState,
      onCreate: (Food food, Completer<CreateEntryResponse> completer) => store.dispatch(CreateEntry(food, completer)),
      onUpdate: (Food food, Completer<CreateEntryResponse> completer) => store.dispatch(UpdateEntry(food, completer)),
    );
  }
}

class CreateEntryResponse {
  final Achievement achievement;

  CreateEntryResponse(this.achievement);
}
