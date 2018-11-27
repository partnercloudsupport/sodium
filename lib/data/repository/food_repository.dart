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
    _sharedPreferencesRepository = SharedPreferencesRepository();

    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });
    _dio = Dio(options);
  }

  Future<List<Food>> search(String query) async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await _dio.get(
      'food/fatsecret?q=$query',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: toBearer(token),
        },
      ),
    );

    final List<Food> foods = FoodParser.fromSearchJsonArray(response.data);
    return foods;
  }

  Future<Food> fetchFoodDetail(int id) async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await _dio.get(
      'food/fatsecret/$id',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final Food food = FoodParser.fromFatSecretDetail(response.data);
    return food;
  }
}
