import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/blood_pressure_section/blood_pressure_screen.dart';

class BloodPressureContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: ProfileBloodPressureSectionViewModel.fromStore,
      builder: (BuildContext context, ProfileBloodPressureSectionViewModel viewModel) {
        return BloodPressureScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
