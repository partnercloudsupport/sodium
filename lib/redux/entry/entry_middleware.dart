import 'package:redux/redux.dart';
import 'package:sodium/data/repository/entry_repository.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/redux/achievement/achievement_action.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/entry/entry_action.dart';

List<Middleware<AppState>> createEntryMiddleware(
  EntryRepository entryRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  final createEntry = _createEntry(entryRepository);
  final fetchEntries = _fetchEntries(entryRepository);
  final deleteEntry = _deleteEntry(entryRepository);

  return [
    TypedMiddleware<AppState, CreateEntry>(createEntry),
    TypedMiddleware<AppState, FetchEntries>(fetchEntries),
    TypedMiddleware<AppState, DeleteEntry>(deleteEntry),
  ];
}

Middleware<AppState> _createEntry(EntryRepository entryRepository) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is CreateEntry) {
      try {
        await entryRepository.createEntry(action.food);
        action.completer.complete(null);

        store.dispatch(FetchAchievements());
        store.dispatch(FetchRecentlyUnlockedAcchivements());
        store.dispatch(FetchEntries());
      } catch (error) {
        print(error);
        action.completer.completeError(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _fetchEntries(
  EntryRepository entryRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is FetchEntries) {
      try {
        final entries = await entryRepository.fetchEntries();
        store.dispatch(StoreEntries(entries));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _deleteEntry(
  EntryRepository entryRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is DeleteEntry) {
      try {
        await entryRepository.deleteEntry(action.id);
        action.completer.complete(null);
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
