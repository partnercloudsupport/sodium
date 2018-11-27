import 'package:flutter/material.dart';
import 'package:sodium/redux/ui/food_add/food_add_state.dart';
import 'package:sodium/redux/ui/food_search/food_search_state.dart';

class UiState {
  final FoodSearchState foodSearchState;
  final FoodAddState foodAddState;

  UiState({
    @required this.foodSearchState,
    @required this.foodAddState,
  });

  factory UiState.initial() {
    return UiState(
      foodAddState: FoodAddState.initial(),
      foodSearchState: FoodSearchState.initial(),
    );
  }

  UiState copyWith({
    FoodSearchState foodSearchState,
    FoodAddState foodAddState,
  }) {
    return UiState(
      foodAddState: foodAddState ?? this.foodAddState,
      foodSearchState: foodSearchState ?? this.foodSearchState,
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
