import 'package:redux/redux.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/redux/ui/food_add/food_add_action.dart';
import 'package:sodium/redux/ui/food_search/food_search_action.dart';
import 'package:sodium/redux/ui/ui_state.dart';

final uiReducers = combineReducers<UiState>([
  TypedReducer<UiState, LoadingFoodSearch>(_foodSearchLoading),
  TypedReducer<UiState, SuccessFoodSearch>(_foodSearchSuccess),
  TypedReducer<UiState, NotFoundFoodSearch>(_foodSearchNotFound),
  TypedReducer<UiState, LoadingFoodSelected>(_foodAddLoading),
  TypedReducer<UiState, SuccessFoodSelected>(_foodAddSuccess),
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
