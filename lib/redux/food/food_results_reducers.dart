import 'package:redux/redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/redux/food/food_action.dart';

final foodResultsReducers = combineReducers<List<Food>>([
  TypedReducer<List<Food>, StoreFoodResults>(_storeFoodSearchResults),
]);

List<Food> _storeFoodSearchResults(List<Food> state, StoreFoodResults action) {
  return action.foods;
}
