import 'package:redux/redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/redux/food/food_action.dart';

final foodUserReducer = combineReducers<List<Food>>([
  TypedReducer<List<Food>, StoreFoodsUser>(storeFoodsUser),
]);

List<Food> storeFoodsUser(List<Food> state, StoreFoodsUser action) {
  return action.food;
}
