import 'package:redux/redux.dart';
import 'package:sodium/data/repository/seasoning_repository.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/seasoning/seasoning_action.dart';

List<Middleware<AppState>> createSeasoningMiddleware(
  SeasoningRepository seasoningRepository,
) {
  final fetchSeasonings = _fetchSeasonings(seasoningRepository);

  return [
    TypedMiddleware<AppState, FetchSeasonings>(fetchSeasonings),
  ];
}

Middleware<AppState> _fetchSeasonings(SeasoningRepository seasoningRepository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchSeasonings) {
      try {
        final seasonings = await seasoningRepository.fetchSeasonings();

        store.dispatch(StoreSeasonings(seasonings));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
