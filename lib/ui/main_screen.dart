import 'package:flutter/material.dart';
import 'package:sodium/bloc/application_bloc.dart';
import 'package:sodium/bloc/bloc_provider.dart';
import 'package:sodium/bloc/overview_bloc.dart';
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
    OverviewBloc overviewBloc = BlocProvider.of<OverviewBloc>(context);

    return StreamBuilder<String>(
      initialData: null,
      stream: applicationBloc.outToken,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        final String token = snapshot.data;

        return token == null
            ? LoginScreen()
//            : BlocProvider<OverviewBloc>(
//                bloc: OverviewBloc(),
//                child: OverviewScreen(),
//              );
            : OverviewScreen();
      },
    );
  }
}
