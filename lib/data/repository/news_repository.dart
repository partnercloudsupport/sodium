import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sodium/constant/http.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/data/parser/news_parser.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/env.dart';
import 'package:sodium/utils/string_util.dart';

class NewsRepository {
  Dio dio;
  SharedPreferencesRepository _sharedPreferencesRepository;

  NewsRepository() {
    _sharedPreferencesRepository = SharedPreferencesRepository();

    final Options options = Options(baseUrl: Environment.baseApi, headers: {
      HttpHeaders.acceptHeader: HttpConstant.httpApplicationJson,
    });

    dio = Dio(options);
  }

  Future<Null> createNews(News news) async {
    final token = await _sharedPreferencesRepository.getToken();

    await dio.post(
      '/news',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
      data: {
        NewsField.title: news.title,
        NewsField.content: news.content,
        NewsField.cover: news.cover,
      },
    );
  }

  Future<List<News>> fetchNews() async {
    final token = await _sharedPreferencesRepository.getToken();

    final response = await dio.get(
      '/news',
      options: Options(headers: {
        HttpHeaders.authorizationHeader: toBearer(token),
      }),
    );

    final news = NewsParser.parseArray(response.data);

    return news;
  }

  Future<Null> update(News news) async {
    final token = await _sharedPreferencesRepository.getToken();

    await dio.put(
      '/news/${news.id}',
      options: Options(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        headers: {
          HttpHeaders.authorizationHeader: toBearer(token),
        },
      ),
      data: {
        NewsField.title: news.title,
        NewsField.content: news.content,
        NewsField.cover: news.cover,
      },
    );
  }

  Future<Null> delete(int newsId) async {
    final token = await _sharedPreferencesRepository.getToken();

    await dio.delete(
      '/news/$newsId',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: toBearer(token),
        },
      ),
    );
  }
}
