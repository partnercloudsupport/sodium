import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/register/register_screen.dart';

class RegisterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: RegisterScreenViewModel.fromStore,
      builder: (BuildContext context, RegisterScreenViewModel viewModel) {
        return RegisterScreen(viewModel: viewModel);
      },
    );
  }
}
