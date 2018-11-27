import 'package:redux/redux.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/redux/mental/mental_action.dart';

final mentalHealthReducers = combineReducers<List<MentalHealth>>([
  TypedReducer<List<MentalHealth>, StoreMentalHealths>(_storeMentalHealths),
]);

List<MentalHealth> _storeMentalHealths(
  List<MentalHealth> state,
  StoreMentalHealths action,
) {
  return action.mentalHealths;
}
