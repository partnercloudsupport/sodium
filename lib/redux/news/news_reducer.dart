import 'package:redux/redux.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/redux/news/news_action.dart';

final newsReducers = combineReducers<List<News>>([
  TypedReducer<List<News>, FetchNewsSuccess>(_fetchNewsSuccess),
]);

List<News> _fetchNewsSuccess(
  List<News> state,
  FetchNewsSuccess action,
) {
  return action.news;
}
