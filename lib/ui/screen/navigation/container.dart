import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/navigation/screen.dart';

class NavigationContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: NavigationViewModel.fromStore,
      builder: (BuildContext context, NavigationViewModel viewModel) {
        return NavigationScreen(viewModel: viewModel);
      },
    );
  }
}
