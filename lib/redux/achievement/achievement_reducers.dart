import 'package:redux/redux.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/redux/achievement/achievement_action.dart';

final achievementReducers = combineReducers<List<Achievement>>([
  TypedReducer<List<Achievement>, StoreAchievements>(_storeAchievements),
]);

List<Achievement> _storeAchievements(
  List<Achievement> state,
  StoreAchievements action,
) {
  return action.achievements;
}
