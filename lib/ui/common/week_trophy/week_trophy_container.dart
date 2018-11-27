import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/common/week_trophy/week_trophy.dart';

class TrophyWeekContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: WeekTrophyViewModel.fromStore,
      builder: (BuildContext context, WeekTrophyViewModel viewModel) {
        return WeekTrophy(
          viewModel: viewModel,
        );
      },
    );
  }
}
