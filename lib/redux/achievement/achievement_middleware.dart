import 'package:redux/redux.dart';
import 'package:sodium/data/repository/achievement_repository.dart';
import 'package:sodium/redux/achievement/achievement_action.dart';
import 'package:sodium/redux/app/app_state.dart';

List<Middleware<AppState>> createAchievementMiddleware(
  AchievementRepository entryRepository,
) {
  final fetchAchievements = _fetchAchievements(entryRepository);
  final fetchRecentlyUnlockedAchievements = _fetchRecentlyUnlockedAchievements(entryRepository);

  return [
    TypedMiddleware<AppState, FetchAchievements>(fetchAchievements),
    TypedMiddleware<AppState, FetchRecentlyUnlockedAcchivements>(fetchRecentlyUnlockedAchievements),
  ];
}

Middleware<AppState> _fetchAchievements(AchievementRepository achievementRepository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchAchievements) {
      try {
        final achievements = await achievementRepository.fetchAchievements();
        store.dispatch(StoreAchievements(achievements));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _fetchRecentlyUnlockedAchievements(AchievementRepository achievementRepository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchRecentlyUnlockedAcchivements) {
      try {
        final achievements = await achievementRepository.fetchRecentlyUnlockedAchievements();
        store.state.achievementsRecentlyUnlocked.add(achievements);
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
