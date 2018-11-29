import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/mental_health_stats/screen.dart';

class MentalHealthContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: MentalHealthScreenViewModel.fromStore,
      builder: (BuildContext context, MentalHealthScreenViewModel viewModel) {
        return MentalHealthStatsScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
