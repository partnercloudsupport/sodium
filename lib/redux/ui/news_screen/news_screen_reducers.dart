import 'package:redux/redux.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/redux/ui/news_screen/news_screen_action.dart';
import 'package:sodium/redux/ui/news_screen/news_screen_state.dart';

final newsScreenReducers = combineReducers<NewsScreenState>([
  TypedReducer<NewsScreenState, ShowNewsLoading>(_showNewsLoading),
  TypedReducer<NewsScreenState, SuccessNewsLoading>(_successLoading),
]);

NewsScreenState _showNewsLoading(
  NewsScreenState state,
  ShowNewsLoading action,
) {
  return state.copyWith(loadingStatus: LoadingStatus.loading);
}

NewsScreenState _successLoading(
  NewsScreenState state,
  SuccessNewsLoading action,
) {
  return state.copyWith(loadingStatus: LoadingStatus.success);
}
