import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/stats/stats_screen.dart';

class StatsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: StatsScreenViewModel.fromStore,
      builder: (BuildContext context, StatsScreenViewModel viewModel) {
        return StatsScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
