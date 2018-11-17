import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sodium/bloc/food_bloc.dart';
import 'package:sodium/bloc/overview/overview_bloc.dart';
import 'package:sodium/bloc/overview/overview_event.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading_status.dart';
import 'package:sodium/ui/common/loading/loading_content.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/common/loading/loading_view.dart';
import 'package:sodium/ui/common/ripple_button.dart';
import 'package:sodium/ui/common/section_container.dart';
import 'package:sodium/ui/common/value_selector.dart';

class FoodAddScreen extends StatefulWidget {
  static final String route = '/food_detail';

  final Food food;

  FoodAddScreen({this.food});

  @override
  _FoodAddScreenState createState() => _FoodAddScreenState();
}

class _FoodAddScreenState extends State<FoodAddScreen> {
  FoodBloc _foodBloc;
  OverviewBloc _overviewBloc;

  int _serving = 1;

  void _save(Food food) {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(),
      barrierDismissible: false,
    );

    final _food = food.copyWith(
      amount: _serving,
      totalSodium: (food.sodium * _serving).toInt(),
    );

    final Completer<Null> completer = Completer();
    completer.future.then((_) {
      Navigator.of(context).pop();
    }).catchError((error) {
      Navigator.of(context).pop();
    });

    final event = CreateEntryEvent(_food, completer);
    _overviewBloc.inEntryCreate.add(event);
  }

  Widget _buildLoadingView(LoadingStatus loadingStatus) {
    return StreamBuilder<Food>(
      stream: _foodBloc.outFoodDetail,
      builder: (context, snapshot) {
        final food = snapshot.data;

        return LoadingView(
          loadingStatus: loadingStatus,
          loadingContent: LoadingContent(title: 'กำลังโหลด'),
          initialContent: loadingStatus != LoadingStatus.loading ? _buildContent(food) : Container(),
        );
      },
    );
  }

  Widget _buildContent(Food food) {
    final nameSection = SectionContainer(
      title: Text(
        '${widget.food.name}',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 28.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Text('${widget.food.type}'),
    );

    final progressSection = SectionContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'รับประทานไปแล้ว 1500',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            'เหลืออีก 1500',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint) {
        return StreamBuilder<double>(
          builder: (context, snapshot) {
            return LinearPercentIndicator(
              width: constraint.maxWidth,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 500,
              percent: double.parse(((_serving * food.sodium) / 3000).toString()),
              center: Text("${snapshot.data}"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            );
          },
        );
      }),
    );

    final servingSection = SectionContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'เลือกจำนวนที่รับประทาน',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            '${(_serving * food.sodium).toString()} มก.',
            style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      body: ValueSelector(
        min: 1,
        max: 15,
        initial: _serving,
        onValueChange: (value) {
          setState(() => _serving = value);
          print('${double.parse(((_serving * food.sodium) / 3000).toString())}');
          //print(double.parse((3000 / (_selectedServing * food.sodium)).toStringAsFixed(1)));
        },
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        nameSection,
        progressSection,
        servingSection,
        SizedBox(height: 36.0),
        RippleButton(
          text: "บันทึก",
          backgroundColor: Theme.of(context).primaryColor,
          highlightColor: Style.highlightColor,
          textColor: Colors.white,
          onPress: () => _save(food),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มบันทึกอาหาร'),
        elevation: .75,
      ),
      backgroundColor: Colors.grey.shade100,
      body: widget.food.isLocal
          ? SingleChildScrollView(
              child: _buildContent(widget.food),
            )
          : StreamBuilder<LoadingStatus>(
              stream: _foodBloc.outFoodDetailLoading,
              initialData: LoadingStatus.loading,
              builder: (context, snapshot) {
                final loadingStatus = snapshot.data;

                return _buildLoadingView(loadingStatus);
              },
            ),
    );
  }
}
