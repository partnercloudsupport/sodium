import 'package:flutter/material.dart';
import 'package:sodium/redux/ui/food_add/food_add_state.dart';
import 'package:sodium/redux/ui/food_search/food_search_state.dart';
import 'package:sodium/redux/ui/news_compose_screen/news_compose_screen_state.dart';
import 'package:sodium/redux/ui/news_list_screen/news_list_screen_state.dart';

class UiState {
  final FoodSearchState foodSearchState;
  final FoodAddState foodAddState;
  final NewsListScreenState newsListScreenState;
  final NewsComposeScreenState newsComposeScreenState;

  UiState({
    @required this.foodSearchState,
    @required this.foodAddState,
    @required this.newsListScreenState,
    @required this.newsComposeScreenState,
  });

  factory UiState.initial() {
    return UiState(
      foodAddState: FoodAddState.initial(),
      foodSearchState: FoodSearchState.initial(),
      newsListScreenState: NewsListScreenState.initial(),
      newsComposeScreenState: NewsComposeScreenState.initial(),
    );
  }

  UiState copyWith({
    FoodSearchState foodSearchState,
    FoodAddState foodAddState,
    NewsListScreenState newsListScreenState,
    NewsComposeScreenState newsComposeScreenState,
  }) {
    return UiState(
      foodAddState: foodAddState ?? this.foodAddState,
      foodSearchState: foodSearchState ?? this.foodSearchState,
      newsListScreenState: newsListScreenState ?? this.newsListScreenState,
      newsComposeScreenState: newsComposeScreenState ?? this.newsComposeScreenState,
    );
  }

  String toJson() {
    return 'UiState{foodSearchState: $foodSearchState, foodAddState: $foodAddState}';
  }

  @override
  String toString() {
    return 'UiState{foodSearchState: $foodSearchState, foodAddState: $foodAddState}';
  }
}
