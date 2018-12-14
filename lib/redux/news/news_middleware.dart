import 'dart:async';

import 'package:redux/redux.dart';
import 'package:sodium/data/repository/news_repository.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/news/news_action.dart';
import 'package:sodium/redux/ui/news_compose_screen/news_compose_screen_action.dart';

List<Middleware<AppState>> createNewsMiddleware(
  NewsRepository newsRepository,
) {
  return [
    TypedMiddleware<AppState, AddNews>(
      _addNews(newsRepository),
    ),
    TypedMiddleware<AppState, UpdateNews>(
      _updateNews(newsRepository),
    ),
    TypedMiddleware<AppState, DeleteNews>(
      _deleteNews(newsRepository),
    ),
    TypedMiddleware<AppState, FetchNews>(
      _fetchNews(newsRepository),
    ),
  ];
}

Middleware<AppState> _addNews(
  NewsRepository newsRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is AddNews) {
      next(ShowNewsComposeLoading());

      try {
        await newsRepository.createNews(action.news);

        action.completer.complete(null);

        //next(BroadcastTopic('แจ้งเตือนข่าวสาร', action.news.title, Environment.notificationTopicNews));
        next(FetchNews());
      } catch (error) {
        print(error);
      }

      next(SuccessNewsComposeLoading());
      next(action);
    }
  };
}

Middleware<AppState> _updateNews(
  NewsRepository newsRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is UpdateNews) {
      next(ShowNewsComposeLoading());

      try {
        await newsRepository.update(action.news);

        action.completer.complete(null);
        next(FetchNews());
      } catch (error) {
        print(error);
      }

      next(SuccessNewsComposeLoading());
      next(action);
    }
  };
}

Middleware<AppState> _deleteNews(
  NewsRepository newsRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is DeleteNews) {
      //      next(ShowNewsLoading());

      try {
        final token = store.state.token;
        await Future.delayed(Duration(seconds: 1));
        await newsRepository.delete(action.newsId);

        action.completer.complete(null);
        next(FetchNews());
      } catch (error) {
        print(error);
      }

      //     next(HideNewsLoading());
      next(action);
    }
  };
}

Middleware<AppState> _fetchNews(
  NewsRepository newsRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchNews) {
      //  next(ShowNewsListLoading());

      try {
        final token = store.state.token;
        final news = await newsRepository.fetchNews();

        print(news);

        action.completer?.complete(null);
        next(FetchNewsSuccess(news));
      } catch (error) {
        print(error);
      }

      //   next(HideNewsListLoading());
      next(action);
    }
  };
}
