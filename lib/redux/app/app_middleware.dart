import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/data/repository/user_repository.dart';
import 'package:sodium/redux/achievement/achievement_action.dart';
import 'package:sodium/redux/app/app_action.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/blood_pressures/blood_pressure_action.dart';
import 'package:sodium/redux/entry/entry_action.dart';
import 'package:sodium/redux/food/food_action.dart';
import 'package:sodium/redux/mental/mental_action.dart';
import 'package:sodium/redux/news/news_action.dart';
import 'package:sodium/redux/seasoning/seasoning_action.dart';
import 'package:sodium/redux/token/token_action.dart';
import 'package:sodium/redux/user/user_action.dart';
import 'package:sodium/service/notification_service.dart';

List<Middleware<AppState>> createAppMiddleware(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
  NotificationService notificationService,
) {
  final init = _init(userRepository, sharedPrefRepository, notificationService);
  final initForNewUser = _initForNewUser(userRepository, sharedPrefRepository, notificationService);

  return [
    TypedMiddleware<AppState, Init>(init),
    TypedMiddleware<AppState, InitForNewUser>(initForNewUser),
  ];
}

Middleware<AppState> _init(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
  NotificationService notificationService,
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
          store.dispatch(FetchRecentlyUnlockedAcchivements());
          store.dispatch(FetchMentalHealths());
          store.dispatch(FetchNews());
          store.dispatch(FetchSeasonings());
          store.dispatch(FetchFoodsUser());
          store.dispatch(FetchBloodPressures());

          notificationService.setDailyNotification(999, 'title', 'body', Time(11, 20, 0));
        }
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _initForNewUser(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
  NotificationService notificationService,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is InitForNewUser) {
      try {
        final String token = await sharedPrefRepository.getToken();

        if (token != null) {
          store.dispatch(StoreToken(token));
          store.dispatch(FetchUser());
          store.dispatch(FetchEntries());
          store.dispatch(FetchAchievements());
          store.dispatch(FetchRecentlyUnlockedAcchivements());
          //store.dispatch(FetchMentalHealths());
          store.dispatch(FetchNews());
          store.dispatch(FetchSeasonings());
          store.dispatch(FetchFoodsUser());
          store.dispatch(FetchBloodPressures());

          // notificationService.setDailyNotification();
        }
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
