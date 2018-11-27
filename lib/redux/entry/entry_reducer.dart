import 'package:redux/redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/redux/entry/entry_action.dart';

final entryReducers = combineReducers<List<Food>>([
  TypedReducer<List<Food>, StoreEntries>(_storeEntries),
]);

List<Food> _storeEntries(List<Food> state, StoreEntries action) {
  return action.entries;
}
