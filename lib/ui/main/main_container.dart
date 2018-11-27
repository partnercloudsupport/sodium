import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/main/main_screen.dart';

class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: MainScreenViewModel.fromStore,
      builder: (BuildContext context, MainScreenViewModel viewModel) {
        return MainScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
