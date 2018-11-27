import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/mental_health_survey/mental_health_survey_screen.dart';

class MentalHealthSurveyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: MentalHealthSurveyScreenViewModel.fromStore,
      builder: (BuildContext context, MentalHealthSurveyScreenViewModel viewModel) {
        return MentalHealthSurveyScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
