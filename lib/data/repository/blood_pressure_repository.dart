import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/data/parser/blood_pressure_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class BloodPressureRepository {
  Dio dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  BloodPressureRepository() {
    _sharedPreferencesRepository = SharedPreferencesRepository();

    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });

    dio = Dio(options);
  }

  Future<Null> createBloodPressure(BloodPressure bloodPressure) async {
    final token = await _sharedPreferencesRepository.getToken();

    await dio.post(
      '/bloodpressure',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
      data: {
        'systolic': bloodPressure.systolic,
        'diastolic': bloodPressure.diastolic,
        'date_time': toMysqlDateTime(bloodPressure.dateTime),
      },
    );
  }

  Future<List<BloodPressure>> fetchBloodPressures() async {
    final token = await _sharedPreferencesRepository.getToken();

    final response = await dio.get(
      '/bloodpressure',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final bloodPressures = BloodPressureParser.parseArray(response.data);
    return bloodPressures;
  }

  Future<Null> updateBloodPressure(BloodPressure bloodPressure) async {
    final token = await _sharedPreferencesRepository.getToken();

    await dio.put(
      '/bloodpressure/${bloodPressure.id}',
      options: Options(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        headers: {
          HttpHeaders.authorizationHeader: toBearer(token),
        },
      ),
      data: {
        'systolic': bloodPressure.systolic,
        'diastolic': bloodPressure.diastolic,
      },
    );
  }

  Future<Null> deleteBloodPressure(int bloodPressureId) async {
    final token = await _sharedPreferencesRepository.getToken();

    await dio.delete(
      '/news/$bloodPressureId',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: toBearer(token),
        },
      ),
    );
  }
}
