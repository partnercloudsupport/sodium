import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/mental_health/mental_health_screen.dart';

class MentalHealthContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: MentalHealthScreenViewModel.fromStore,
      builder: (BuildContext context, MentalHealthScreenViewModel viewModel) {
        return MentalHealthScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
