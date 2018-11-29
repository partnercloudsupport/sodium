import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/food/food_action.dart';
import 'package:sodium/ui/screen/entry_add/screen.dart';

class FoodAddContainer extends StatelessWidget {
  final Food food;

  FoodAddContainer({
    this.food,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      onInit: (Store<AppState> store) {
        if (!food.isLocal) {
          store.dispatch(FetchFoodSelected(food.id));
        }
      },
      converter: FoodAddScreenViewModel.fromStore,
      builder: (BuildContext context, FoodAddScreenViewModel viewModel) {
        return AddEntryScreen(
          food: food,
          viewModel: viewModel,
        );
      },
    );
  }
}
