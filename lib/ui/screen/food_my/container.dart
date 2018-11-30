import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/food_my/screen.dart';

class MyFoodContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: MyFoodScreenViewModel.fromStore,
      builder: (BuildContext context, MyFoodScreenViewModel viewModel) {
        return MyFoodScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
