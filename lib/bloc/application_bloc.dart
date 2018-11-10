import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sodium/bloc/bloc_provider.dart';
import 'package:sodium/data/model/loading_status.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/data/repository/user_repository.dart';

class ApplicationBloc extends BlocBase {
  UserRepository userRepository = UserRepository();
  SharedPreferencesRepository sharedPreferencesRepository = SharedPreferencesRepository();

  //@formatter:off
  BehaviorSubject<String> _tokenController = BehaviorSubject<String>();
  Stream<String> get outToken => _tokenController.stream;
  Sink<String> get _inToken => _tokenController.sink;

  BehaviorSubject<User> _userController = BehaviorSubject<User>();
  Stream<User> get outUser => _userController.stream;
  Sink<User> get _inUser => _userController.sink;

  BehaviorSubject<User> _userUpdateController = BehaviorSubject<User>();
  Sink<User> get inUpdateUser => _userUpdateController.sink;

  BehaviorSubject<Null> _userLogoutController = BehaviorSubject<Null>();
  Sink<Null> get inLogoutUser => _userLogoutController.sink;

  BehaviorSubject<LoginEvent> _userLoginController = BehaviorSubject<LoginEvent>();
  Sink<LoginEvent> get inLoginUser => _userLoginController.sink;

  BehaviorSubject<LoadingStatus> _loginLoadingController = BehaviorSubject<LoadingStatus>();
  Stream<LoadingStatus> get outLoginLoading => _loginLoadingController.stream;

  BehaviorSubject<RegisterEvent> _userRegisterController = BehaviorSubject<RegisterEvent>();
  Sink<RegisterEvent> get inRegisterUser => _userRegisterController.sink;

  BehaviorSubject<LoadingStatus> _registerLoadingController = BehaviorSubject<LoadingStatus>();
  Stream<LoadingStatus> get outRegisterLoading => _registerLoadingController.stream;
  //@formatter:on

  ApplicationBloc() {
    _loadToken();

    _userLoginController.listen((LoginEvent event) {
      _loginLoadingController.addStream(_login(event));
    });

    _userRegisterController.listen((RegisterEvent event) {
      _registerLoadingController.addStream(_register(event));
    });

    _userLogoutController.listen((_) {
      _logout();
    });

    _tokenController.listen((String token) {
      if (token != null) {
        _fetchUser(token);
      }
    });
  }

  void _fetchUser(String token) async {
    try {
      final User user = await userRepository.fetchDetail(token);
      _inUser.add(user);
    } catch (error) {
      print(error);
    }
  }

  Stream<LoadingStatus> _login(LoginEvent event) async* {
    yield LoadingStatus.loading;

    try {
      final User user = await userRepository.login(event.email, event.password);
      await sharedPreferencesRepository.saveToken(user.token);

      _inUser.add(user);
      _inToken.add(user.token);

      yield LoadingStatus.success;
      event.completer.complete(null);
    } catch (error) {
      yield LoadingStatus.initial;
      event.completer.completeError(error);
    }
  }

  void _logout() async {
    _inUser.add(null);
    _inToken.add(null);

    await sharedPreferencesRepository.deleteToken();
  }

  Stream<LoadingStatus> _register(RegisterEvent event) async* {
    yield LoadingStatus.loading;

    try {
      await userRepository.register(event.user);
      yield LoadingStatus.success;

      event.completer.complete(null);
    } catch (error) {
      yield LoadingStatus.initial;
      event.completer.completeError(error);
    }
  }

  void _loadToken() async {
    final String token = await sharedPreferencesRepository.getToken();

    if (token != null) {
      _inToken.add(token);
    }
  }


  @override
  void dispose() {
    _tokenController.close();
    _userController.close();
    _userUpdateController.close();
    _userLogoutController.close();
    _userLoginController.close();
    _loginLoadingController.close();
    _userRegisterController.close();
    _registerLoadingController.close();
  }
}

class LoginEvent {
  final String email;
  final String password;
  final Completer<Null> completer;

  LoginEvent({
    @required this.email,
    @required this.password,
    this.completer,
  });
}


class RegisterEvent {
  final User user;
  final Completer<Null> completer;

  RegisterEvent({
    @required this.user,
    this.completer,
  });
}
