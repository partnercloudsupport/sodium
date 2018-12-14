import 'package:redux/redux.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/redux/ui/news_compose_screen/news_compose_screen_action.dart';
import 'package:sodium/redux/ui/news_compose_screen/news_compose_screen_state.dart';

final newsComposeReducers = combineReducers<NewsComposeScreenState>([
  new TypedReducer<NewsComposeScreenState, ShowNewsComposeLoading>(_showLoginLoading),
  new TypedReducer<NewsComposeScreenState, SuccessNewsComposeLoading>(_successLoading),
]);

NewsComposeScreenState _showLoginLoading(
  NewsComposeScreenState state,
  ShowNewsComposeLoading action,
) {
  return state.copyWith(loadingStatus: LoadingStatus.loading);
}

NewsComposeScreenState _successLoading(
  NewsComposeScreenState state,
  SuccessNewsComposeLoading action,
) {
  return state.copyWith(loadingStatus: LoadingStatus.success);
}
