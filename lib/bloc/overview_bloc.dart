import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sodium/bloc/bloc_provider.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/repository/food_repository.dart';

class OverviewBloc extends BlocBase {
  final FoodRepository foodRepository = FoodRepository();

  //@formatter:off
  BehaviorSubject<List<Food>> _foodsController = BehaviorSubject<List<Food>>();

  Stream<List<Food>> get outFoods => _foodsController.stream;
  Sink<List<Food>> get _inFoods => _foodsController.sink;
  //@formatter:on

  OverviewBloc() {
    _fetchFood();
  }

  void _fetchFood() async {
    try {
      final List<Food> foods = await foodRepository.search('pepsi');
      _inFoods.add(foods.take(5).toList());
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _foodsController.close();
  }
}
