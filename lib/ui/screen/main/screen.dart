import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/screen/login/container.dart';
import 'package:sodium/ui/screen/navigation/container.dart';

class MainScreen extends StatefulWidget {
  static const String route = '/main';

  final MainScreenViewModel viewModel;

  MainScreen({
    this.viewModel,
  });

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return viewModel.token == null ? LoginContainer() : NavigationContainer();
  }
}

class MainScreenViewModel {
  final User user;
  final String token;

  MainScreenViewModel({
    @required this.user,
    @required this.token,
  });

  static MainScreenViewModel fromStore(Store<AppState> store) {
    return MainScreenViewModel(
      user: store.state.user,
      token: store.state.token,
    );
  }
}
