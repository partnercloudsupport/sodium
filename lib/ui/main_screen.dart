import 'package:flutter/material.dart';
import 'package:sodium/bloc/application/application_bloc.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/ui/login_screen.dart';
import 'package:sodium/ui/overview_screen.dart';

class MainScreen extends StatefulWidget {
  static const String route = '/main';

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    return StreamBuilder<String>(
      initialData: null,
      stream: applicationBloc.outToken,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        final String token = snapshot.data;

        return token == null ? LoginScreen() : OverviewScreen();
      },
    );
  }
}
