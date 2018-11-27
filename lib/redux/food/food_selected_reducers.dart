import 'package:redux/redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/redux/food/food_action.dart';

final foodSelectedReducers = combineReducers<Food>([
  TypedReducer<Food, StoreFoodSelected>(_storeFoodSearchSelected),
]);

Food _storeFoodSearchSelected(Food state, StoreFoodSelected action) {
  return action.food;
}
