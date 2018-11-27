import 'package:redux/redux.dart';
import 'package:sodium/data/repository/mental_repository.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/mental/mental_action.dart';

List<Middleware<AppState>> createMentalHealthsMiddleware(
  MentalRepository mentalRepository,
) {
  final fetchMentalHealths = _fetchMentalHealths(mentalRepository);
  final createMentalHealth = _createMentalHealth(mentalRepository);

  return [
    TypedMiddleware<AppState, FetchMentalHealths>(fetchMentalHealths),
    TypedMiddleware<AppState, CreateMentalHealth>(createMentalHealth),
  ];
}

Middleware<AppState> _fetchMentalHealths(MentalRepository mentalHealthsRepository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchMentalHealths) {
      try {
        final mentalHealths = await mentalHealthsRepository.fetchMentalHealths();
        store.state.mentalHealthsStream.add(mentalHealths);

        store.dispatch(StoreMentalHealths(mentalHealths));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _createMentalHealth(MentalRepository mentalHealthsRepository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is CreateMentalHealth) {
      try {
        await mentalHealthsRepository.createEntry(action.mentalHealth);
        action.completer.complete(null);
      } catch (error) {
        print(error);
        action.completer.completeError(error);
      }

      next(action);
    }
  };
}
