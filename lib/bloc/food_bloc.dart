import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading_status.dart';
import 'package:sodium/data/repository/food_repository.dart';

class FoodBloc extends BlocBase {
  final FoodRepository foodRepository = FoodRepository();

  //@formatter:off

  // Foods
  BehaviorSubject<List<Food>> _foodsController = BehaviorSubject<List<Food>>();
  Stream<List<Food>> get outFoods => _foodsController.stream;
  Sink<List<Food>> get _inFoods => _foodsController.sink;

  // Foods Search
  String _query = '';
  BehaviorSubject<String> _foodsSearchController = BehaviorSubject<String>();
  Stream<String> get outSearchFood => _foodsSearchController.stream;
  Sink<String> get inSearchFood => _foodsSearchController.sink;

  //Food Search Loading
  BehaviorSubject<LoadingStatus> _foodSearchLoadingController = BehaviorSubject<LoadingStatus>();
  Stream<LoadingStatus> get outFoodSearchLoading => _foodSearchLoadingController.stream;

  // Food Detail
  StreamController<Food> _foodDetailController = StreamController<Food>.broadcast();
  Stream<Food> get outFoodDetail => _foodDetailController.stream;
  Sink<Food> get inFoodDetail => _foodDetailController.sink;

  // Food Detail Search
  BehaviorSubject<Food> _foodDetailSearchController = BehaviorSubject<Food>();
  Stream<Food> get outFoodDetailSearch => _foodDetailSearchController.stream;
  Sink<Food> get inFoodDetailSearch => _foodDetailSearchController.sink;

  // Food Detail Loading
  BehaviorSubject<LoadingStatus> _foodDetailLoadingController = BehaviorSubject<LoadingStatus>();
  Stream<LoadingStatus> get outFoodDetailLoading => _foodDetailLoadingController.stream;

//@formatter:on

  FoodBloc() {
    _foodsSearchController.debounce(Duration(milliseconds: 500)).listen((String query) {
//      if (query.isEmpty) {
//        _inFoods.add([]);
//        _inFoodSearchLoading.add(LoadingStatus.initial);
//        return;
//      }

      if (query == _query) {
        return;
      }

      _query = query;
      _foodSearchLoadingController.addStream(_fetchFoodsByName(query));
    });

    _foodDetailSearchController.listen((Food food) {
      _foodDetailLoadingController.addStream(_fetchFoodDetail(food.id));
    });
  }

  Stream<LoadingStatus> _fetchFoodsByName(String query) async* {
    yield LoadingStatus.loading;

    try {
      final List<Food> foods = await foodRepository.search(query);
      _inFoods.add(foods.toList());

      if (foods.isEmpty) {
        yield LoadingStatus.notFound;
      } else {
        yield LoadingStatus.success;
      }
    } catch (e) {
      yield LoadingStatus.notFound;
    }
  }

  Stream<LoadingStatus> _fetchFoodDetail(int id) async* {
    yield LoadingStatus.loading;

    try {
      final Food food = await foodRepository.fetchFoodDetail(id);
      inFoodDetail.add(food);

      yield LoadingStatus.success;
    } catch (error) {
      yield LoadingStatus.initial;
    }
  }

  @override
  void dispose() {
    _foodsController.close();
    _foodsSearchController.close();
    _foodSearchLoadingController.close();
    _foodDetailController.close();
    _foodDetailLoadingController.close();
    _foodDetailSearchController.close();
  }
}
