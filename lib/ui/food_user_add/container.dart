import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/food_user_add/screen.dart';

class MyFoodAddContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: MyFoodAddScreenViewModel.fromStore,
      builder: (BuildContext context, MyFoodAddScreenViewModel viewModel) {
        return MyFoodAddScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
