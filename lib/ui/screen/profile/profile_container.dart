import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/profile/profile_screen.dart';

class ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: ProfileScreenViewModel.fromStore,
      builder: (BuildContext context, ProfileScreenViewModel viewModel) {
        return ProfileScreen(viewModel: viewModel);
      },
    );
  }
}
