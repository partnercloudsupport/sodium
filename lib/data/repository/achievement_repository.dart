import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/data/parser/accievement_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class AchievementRepository {
  Dio _dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  AchievementRepository() {
    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });
    _dio = Dio(options);

    _sharedPreferencesRepository = SharedPreferencesRepository();
  }

  Future<List<Achievement>> fetchAchievements() async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await _dio.get(
      '/achievement',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final achievements = AchievementParser.fromJsonArray(response.data);
    return achievements;
  }

  Future<List<Achievement>> fetchRecentlyUnlockedAchievements() async {
    final token = await _sharedPreferencesRepository.getToken();
    final response = await _dio.get(
      '/achievement/unlock',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final achievements = AchievementParser.fromJsonArray(response.data);
    return achievements;
  }
}
