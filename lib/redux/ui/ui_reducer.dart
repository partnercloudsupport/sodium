import 'package:redux/redux.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/redux/ui/food_add/food_add_action.dart';
import 'package:sodium/redux/ui/food_search/food_search_action.dart';
import 'package:sodium/redux/ui/news_compose_screen/news_compose_screen_action.dart';
import 'package:sodium/redux/ui/news_list_screen/news_list_screen_action.dart';
import 'package:sodium/redux/ui/ui_state.dart';

final uiReducers = combineReducers<UiState>([
  TypedReducer<UiState, LoadingFoodSearch>(_foodSearchLoading),
  TypedReducer<UiState, SuccessFoodSearch>(_foodSearchSuccess),
  TypedReducer<UiState, NotFoundFoodSearch>(_foodSearchNotFound),
  TypedReducer<UiState, LoadingFoodSelected>(_foodAddLoading),
  TypedReducer<UiState, SuccessFoodSelected>(_foodAddSuccess),
  TypedReducer<UiState, ShowNewsListLoading>(_showNewsListLoading),
  TypedReducer<UiState, SuccessNewsListLoading>(_successNewsListLoading),
  TypedReducer<UiState, ShowNewsComposeLoading>(_showNewsComposerLoading),
  TypedReducer<UiState, SuccessNewsComposeLoading>(_successComposerLoading),
]);

UiState _foodSearchLoading(
  UiState state,
  LoadingFoodSearch action,
) {
  final newFoodSearchState = state.foodSearchState.copyWith(
    loadingStatus: LoadingStatus.loading,
  );

  return state.copyWith(foodSearchState: newFoodSearchState);
}

UiState _foodSearchSuccess(
  UiState state,
  SuccessFoodSearch action,
) {
  final newFoodSearchState = state.foodSearchState.copyWith(
    loadingStatus: LoadingStatus.success,
  );

  return state.copyWith(foodSearchState: newFoodSearchState);
}

UiState _foodSearchNotFound(
  UiState state,
  NotFoundFoodSearch action,
) {
  final newFoodSearchState = state.foodSearchState.copyWith(
    loadingStatus: LoadingStatus.notFound,
  );

  return state.copyWith(foodSearchState: newFoodSearchState);
}

UiState _foodAddLoading(
  UiState state,
  LoadingFoodSelected action,
) {
  final newFoodAddState = state.foodAddState.copyWith(
    loadingStatus: LoadingStatus.loading,
  );

  return state.copyWith(foodAddState: newFoodAddState);
}

UiState _foodAddSuccess(
  UiState state,
  SuccessFoodSelected action,
) {
  final newFoodAddState = state.foodAddState.copyWith(
    loadingStatus: LoadingStatus.success,
  );

  return state.copyWith(foodAddState: newFoodAddState);
}

UiState _showNewsListLoading(
  UiState state,
  ShowNewsListLoading action,
) {
  final newNewsListState = state.newsListScreenState.copyWith(
    loadingStatus: LoadingStatus.loading,
  );

  return state.copyWith(newsListScreenState: newNewsListState);
}

UiState _successNewsListLoading(
  UiState state,
  SuccessNewsListLoading action,
) {
  final newNewsListState = state.newsListScreenState.copyWith(
    loadingStatus: LoadingStatus.success,
  );

  return state.copyWith(newsListScreenState: newNewsListState);
}

UiState _showNewsComposerLoading(
  UiState state,
  ShowNewsComposeLoading action,
) {
  final newNewsComposeState = state.newsComposeScreenState.copyWith(
    loadingStatus: LoadingStatus.loading,
  );

  return state.copyWith(newsComposeScreenState: newNewsComposeState);
}

UiState _successComposerLoading(
  UiState state,
  SuccessNewsComposeLoading action,
) {
  final newNewsComposeState = state.newsComposeScreenState.copyWith(
    loadingStatus: LoadingStatus.success,
  );

  return state.copyWith(newsComposeScreenState: newNewsComposeState);
}
