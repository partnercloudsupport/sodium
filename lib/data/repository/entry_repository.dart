import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/parser/food_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class EntryRepository {
  Dio _dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  EntryRepository() {
    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });

    _dio = Dio(options);

    _sharedPreferencesRepository = SharedPreferencesRepository();
  }

  Future<List<Food>> fetchEntries() async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await _dio.get(
      '/entry',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final foods = FoodParser.fromEntryJsonArray(response.data);
    return foods;
  }

  Future<Null> createEntry(Food food) async {
    final token = await _sharedPreferencesRepository.getToken();

    await _dio.post(
      'entry',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
      data: {
        'food_id': food.id.toString(),
        'food_name': food.name,
        'food_sodium': food.sodium.toString(),
        'food_type': food.type,
        'total_sodium': food.totalSodium.toString(),
        'is_local': food.isLocal,
        'serving': food.serving,
        'seasonings': json.encode(food.seasonings),
        'date_time': toMysqlDateTime(food.dateTime),
      },
    );
  }

  Future<Null> updateEntry(Food food) async {
    final token = await _sharedPreferencesRepository.getToken();

    await _dio.put(
      'entry/${food.entryId}',
      options: Options(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        headers: {
          HttpHeaders.authorizationHeader: toBearer(token),
        },
      ),
      data: {
        'total_sodium': food.totalSodium.toString(),
        'serving': food.serving,
        'date_time': toMysqlDateTime(food.dateTime),
      },
    );
  }

  Future<Null> deleteEntry(int id) async {
    final token = await _sharedPreferencesRepository.getToken();

    await _dio.delete(
      'entry/$id',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );
  }

  Future<List<Food>> search(String query) async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await _dio.get(
      'food/fatsecret?q=$query',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final List<Food> foods = FoodParser.fromSearchJsonArray(response.data);
    return foods;
  }
}
