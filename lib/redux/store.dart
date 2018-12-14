import 'package:redux/redux.dart';
import 'package:sodium/data/repository/achievement_repository.dart';
import 'package:sodium/data/repository/entry_repository.dart';
import 'package:sodium/data/repository/food_repository.dart';
import 'package:sodium/data/repository/mental_repository.dart';
import 'package:sodium/data/repository/news_repository.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/data/repository/seasoning_repository.dart';
import 'package:sodium/data/repository/user_repository.dart';
import 'package:sodium/redux/achievement/achievement_middleware.dart';
import 'package:sodium/redux/app/app_middleware.dart';
import 'package:sodium/redux/app/app_reducer.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/entry/entry_middleware.dart';
import 'package:sodium/redux/food/food_middleware.dart';
import 'package:sodium/redux/mental/mental_middleware.dart';
import 'package:sodium/redux/news/news_middleware.dart';
import 'package:sodium/redux/seasoning/seasoning_middleware.dart';
import 'package:sodium/redux/user/user_middleware.dart';

Future<Store<AppState>> createStore() async {
  final userRepository = UserRepository();
  final prefsRepository = SharedPreferencesRepository();
  final entryRepository = EntryRepository();
  final foodRepository = FoodRepository();
  final achievementRepository = AchievementRepository();
  final mentalHealthsRepository = MentalRepository();
  final seasoningRepository = SeasoningRepository();
  final newsRepository = NewsRepository();
//  final remote = RemoteDevToolsMiddleware('192.168.2.106:8001');
//  await remote.connect();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: []
//      ..add(remote)
      ..addAll(createAppMiddleware(userRepository, prefsRepository))
      ..addAll(createUserMiddleware(userRepository, prefsRepository))
      ..addAll(createEntryMiddleware(entryRepository, prefsRepository))
      ..addAll(createFoodMiddleware(foodRepository, prefsRepository))
      ..addAll(createAchievementMiddleware(achievementRepository))
      ..addAll(createMentalHealthsMiddleware(mentalHealthsRepository))
      ..addAll(createSeasoningMiddleware(seasoningRepository))
      ..addAll(createNewsMiddleware(newsRepository)),
  );

//  remote.store = store;

  return store;
}
