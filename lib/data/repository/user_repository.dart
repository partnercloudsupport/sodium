import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/data/parser/user_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class UserRepository {
  Dio dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  UserRepository() {
    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });

    dio = Dio(options);
    _sharedPreferencesRepository = SharedPreferencesRepository();
  }

  Future<User> login(String email, String password) async {
    final response = await dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    final User user = UserParser.parse(response.data);
    return user;
  }

  Future<User> register(User user) async {
    final response = await dio.post('/register', data: {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    });

    final User _user = UserParser.parse(response.data);
    return _user;
  }

  Future<User> fetchDetail(String token) async {
    final response = await dio.get(
      '/user',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final User user = UserParser.parse(response.data);
    return user;
  }

  Future<Null> update(User user) async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await dio.put('/user',
        options: Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded"),
          headers: {
            HttpHeaders.authorizationHeader: toBearer(token),
          },
        ),
        data: {
          'name': user.name,
          'date_of_birth': user.dateOfBirth,
          'health_condition': user.healthCondition,
          'gender': user.gender,
          'sodium_limit': user.sodiumLimit,
          'is_new_user': user.isNewUser ? 1 : 0,
        });
  }
}

class UnauthorizedException implements Exception {
  String error;

  UnauthorizedException(this.error);
}
