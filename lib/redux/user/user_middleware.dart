import 'package:redux/redux.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/data/repository/user_repository.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/token/token_action.dart';
import 'package:sodium/redux/user/user_action.dart';

List<Middleware<AppState>> createUserMiddleware(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  final register = _register(userRepository);
  final login = _login(userRepository, sharedPrefRepository);
  final logout = _logout(userRepository, sharedPrefRepository);
  final update = _update(userRepository);
  final fetchUser = _fetchUser(userRepository);

  return [
    TypedMiddleware<AppState, Register>(register),
    TypedMiddleware<AppState, Login>(login),
    TypedMiddleware<AppState, Logout>(logout),
    TypedMiddleware<AppState, UpdateUser>(update),
    TypedMiddleware<AppState, FetchUser>(fetchUser),
  ];
}

Middleware<AppState> _login(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is Login) {
      try {
        User user = await userRepository.login(action.email, action.password);
        store.dispatch(StoreUser(user));

        await sharedPrefRepository.saveToken(user.token);
        store.dispatch(StoreToken(user.token));

        action.completer.complete(null);
      } catch (error) {
        action.completer.completeError(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _logout(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is Logout) {
      try {
        await sharedPrefRepository.deleteToken();
        // next(ClearAppState());
      } catch (error) {}
      next(action);
    }
  };
}

Middleware<AppState> _fetchUser(
  UserRepository userRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchUser) {
      try {
        final token = store.state.token;
        final user = await userRepository.fetchDetail(token);

        store.dispatch(StoreUser(user));
      } catch (error) {}

      next(action);
    }
  };
}

Middleware<AppState> _register(
  UserRepository userRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is Register) {
      try {
        final user = await userRepository.register(action.user);
        //  next(SaveToken(user.token));
        next(FetchUser());
        action.completer.complete(null);
      } catch (error) {
        action.completer.completeError(null);
      }

      next(action);
    }
  };
}

Middleware<AppState> _update(
  UserRepository userRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is UpdateUser) {
      try {
        final token = store.state.token;
        // await userRepository.update(token, action.user);
        next(FetchUser());
        action.completer.complete(null);
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
