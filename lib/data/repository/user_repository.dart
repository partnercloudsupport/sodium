import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/data/parser/user_parser.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class UserRepository {
  Dio dio;

  UserRepository() {
    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });

    dio = Dio(options);
  }

  Future<User> login(String email, String password) async {
    final response = await dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    final User user = UserParser.parse(response.data);
    return user;
  }

  Future<Null> register(User user) async {
    final response = await dio.post('/register', data: {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    });
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
}

class UnauthorizedException implements Exception {
  String error;

  UnauthorizedException(this.error);
}
