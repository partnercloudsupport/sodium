import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/achievements/screen.dart';

class AchievementsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: AchievementsScreenViewModel.fromStore,
      builder: (BuildContext context, AchievementsScreenViewModel viewModel) {
        return AchievementsScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
