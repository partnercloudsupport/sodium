import 'package:flutter/material.dart';
import 'package:sodium/data/model/loading.dart';

class FoodAddState {
  final LoadingStatus loadingStatus;

  FoodAddState({
    @required this.loadingStatus,
  });

  factory FoodAddState.initial() {
    return FoodAddState(loadingStatus: LoadingStatus.initial);
  }

  FoodAddState copyWith({LoadingStatus loadingStatus}) {
    return FoodAddState(loadingStatus: loadingStatus ?? this.loadingStatus);
  }

  @override
  String toString() {
    return 'FoodAddState{loadingStatus: $loadingStatus}';
  }

  String toJson() {
    return 'FoodAddState{loadingStatus: $loadingStatus}';
  }
}
