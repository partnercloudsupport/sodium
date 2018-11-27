import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/food_search/food_search_screen.dart';

class FoodSearchContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: FoodSearchScreenViewModel.fromStore,
      builder: (BuildContext context, FoodSearchScreenViewModel viewModel) {
        return FoodSearchScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
