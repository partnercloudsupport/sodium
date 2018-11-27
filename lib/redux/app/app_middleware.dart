import 'package:redux/redux.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/data/repository/user_repository.dart';
import 'package:sodium/redux/achievement/achievement_action.dart';
import 'package:sodium/redux/app/app_action.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/entry/entry_action.dart';
import 'package:sodium/redux/mental/mental_action.dart';
import 'package:sodium/redux/token/token_action.dart';
import 'package:sodium/redux/user/user_action.dart';

List<Middleware<AppState>> createAppMiddleware(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  final init = _init(userRepository, sharedPrefRepository);

  return [
    TypedMiddleware<AppState, Init>(init),
  ];
}

Middleware<AppState> _init(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is Init) {
      try {
        final String token = await sharedPrefRepository.getToken();

        if (token != null) {
          store.dispatch(StoreToken(token));
          store.dispatch(FetchUser());
          store.dispatch(FetchEntries());
          store.dispatch(FetchAchievements());
          store.dispatch(FetchMentalHealths());
        }
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
