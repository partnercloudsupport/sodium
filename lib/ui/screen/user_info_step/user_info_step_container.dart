import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/user_info_step/user_info_step_screen.dart';

class UserStepInfoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: UserStepInfoScreeViewModel.fromStore,
      builder: (BuildContext context, UserStepInfoScreeViewModel viewModel) {
        return UserInfoStepScreen(viewModel: viewModel);
      },
    );
  }
}
