import 'package:sodium/redux/achievement/achievement_reducers.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/entry/entry_reducer.dart';
import 'package:sodium/redux/food/food_results_reducers.dart';
import 'package:sodium/redux/food/food_selected_reducers.dart';
import 'package:sodium/redux/food/food_user_reducer.dart';
import 'package:sodium/redux/mental/mental_reducers.dart';
import 'package:sodium/redux/seasoning/seasoning_reducers.dart';
import 'package:sodium/redux/token/token_reducers.dart';
import 'package:sodium/redux/ui/ui_reducer.dart';
import 'package:sodium/redux/user/user_reducer.dart';

AppState appReducer(AppState state, action) {
  final appState = AppState(
    user: userReducers(state.user, action),
    token: tokenReducers(state.token, action),
    entries: entryReducers(state.entries, action),
    foodSearchResults: foodResultsReducers(state.foodSearchResults, action),
    foodSearchSelected: foodSelectedReducers(state.foodSearchSelected, action),
    userFoods: foodUserReducer(state.userFoods, action),
    seasonings: seasoningReducers(state.seasonings, action),
    achievements: achievementReducers(state.achievements, action),
    achievementsRecentlyUnlockedStream: state.achievementsRecentlyUnlockedStream,
    mentalHealthsStream: state.mentalHealthsStream,
    mentalHealths: mentalHealthReducers(state.mentalHealths, action),
    uiState: uiReducers(state.uiState, action),
  );

  return appState;
}
