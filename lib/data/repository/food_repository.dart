import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/parser/food_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class FoodRepository {
  Dio _dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  FoodRepository() {
    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });
    _dio = Dio(options);

    _sharedPreferencesRepository = SharedPreferencesRepository();
  }

  Future<List<Food>> search(String keyword) async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await _dio.get(
      'food/fatsecret?q=$keyword',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final List<Food> foods = FoodParser.fromFatSecretJsonArray(response.data['foods']['food']);
    return foods;
  }
}
