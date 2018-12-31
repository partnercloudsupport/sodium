import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/screen/food_user/screen.dart';

class UserFoodContainer extends StatelessWidget {
  final Function(Food food) onFoodClick;

  UserFoodContainer({
    @required this.onFoodClick,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: MyFoodScreenViewModel.fromStore,
      builder: (BuildContext context, MyFoodScreenViewModel viewModel) {
        return UserFoodScreen(
          viewModel: viewModel,
          onFoodClick: onFoodClick,
        );
      },
    );
  }
}
