import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/data/parser/seasoning_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class SeasoningRepository {
  Dio _dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  SeasoningRepository() {
    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });

    _dio = Dio(options);

    _sharedPreferencesRepository = SharedPreferencesRepository();
  }

  Future<List<Seasoning>> fetchSeasonings() async {
    final token = await _sharedPreferencesRepository.getToken();

    final response = await _dio.get(
      'seasoning',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final seasonings = SeasoningParser.fromJsonArray(response.data);

    return seasonings;
  }
}
