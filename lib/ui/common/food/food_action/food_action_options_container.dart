import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/common/food/food_action/food_action_options.dart';

class FoodActionOptionContainer extends StatelessWidget {
  final Food food;
  final BuildContext parentContext;

  FoodActionOptionContainer({
    Key key,
    this.food,
    this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: FoodActionOptionViewModel.fromStore,
      builder: (BuildContext context, FoodActionOptionViewModel viewModel) {
        return FoodActionOptions(
          viewModel: viewModel,
          food: food,
          context: parentContext,
        );
      },
    );
  }
}
