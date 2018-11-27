import 'package:flutter/material.dart';
import 'package:sodium/data/model/loading_status.dart';

class FoodSearchState {
  final LoadingStatus loadingStatus;

  FoodSearchState({
    @required this.loadingStatus,
  });

  factory FoodSearchState.initial() {
    return FoodSearchState(loadingStatus: LoadingStatus.initial);
  }

  FoodSearchState copyWith({LoadingStatus loadingStatus}) {
    return FoodSearchState(loadingStatus: loadingStatus ?? this.loadingStatus);
  }

  @override
  String toString() {
    return 'FoodSearchState{loadingStatus: $loadingStatus}';
  }

  String toJson() {
    return 'FoodSearchState{loadingStatus: $loadingStatus}';
  }
}
