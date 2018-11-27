import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/data/parser/mental_health_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class MentalRepository {
  Dio _dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  MentalRepository() {
    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });

    _dio = Dio(options);

    _sharedPreferencesRepository = SharedPreferencesRepository();
  }

  Future<List<MentalHealth>> fetchMentalHealths() async {
    final token = await _sharedPreferencesRepository.getToken();

    final response = await _dio.get(
      'mentalhealth',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final mentalHealths = MentalHealthParser.fromJsonArray(response.data);

    return mentalHealths;
  }

  Future<Null> createEntry(MentalHealth mentalHealth) async {
    final token = await _sharedPreferencesRepository.getToken();

    final response = await _dio.post(
      'mentalhealth',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
      data: {
        'level': mentalHealth.level,
        'date_time': toMysqlDateTime(mentalHealth.datetime),
      },
    );
  }
}
