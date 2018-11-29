import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/login/screen.dart';

class LoginContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: LoginScreenViewModel.fromStore,
      builder: (BuildContext context, LoginScreenViewModel viewModel) {
        return LoginScreen(viewModel: viewModel);
      },
    );
  }
}
