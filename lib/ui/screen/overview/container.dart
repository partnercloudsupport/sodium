import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/overview/screen.dart';

class OverviewContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: OverviewScreenViewModel.fromStore,
      builder: (BuildContext context, OverviewScreenViewModel viewModel) {
        return OverviewScreen(
          key: Key('__overview_screen__'),
          viewModel: viewModel,
        );
      },
    );
  }
}
