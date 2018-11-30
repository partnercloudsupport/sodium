import 'package:redux/redux.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/redux/seasoning/seasoning_action.dart';

final seasoningReducers = combineReducers<List<Seasoning>>([
  TypedReducer<List<Seasoning>, StoreSeasonings>(_storeSeasonings),
]);

List<Seasoning> _storeSeasonings(
  List<Seasoning> state,
  StoreSeasonings action,
) {
  return action.seasonings;
}
