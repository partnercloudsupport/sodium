import 'package:flutter/material.dart';
import 'package:sodium/bloc/application/application_bloc.dart';
import 'package:sodium/bloc/food_bloc.dart';
import 'package:sodium/bloc/overview/overview_bloc.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/ui/food_add.dart';
import 'package:sodium/ui/food_search.dart';
import 'package:sodium/ui/login_screen.dart';
import 'package:sodium/ui/main_screen.dart';
import 'package:sodium/ui/register_screen.dart';

void main() => runApp(
      BlocProvider<ApplicationBloc>(
        bloc: ApplicationBloc(),
        child: BlocProvider<OverviewBloc>(
          bloc: OverviewBloc(),
          child: BlocProvider<FoodBloc>(
            bloc: FoodBloc(),
            child: SodiumApp(),
          ),
        ),
      ),
    );

class SodiumApp extends StatelessWidget {
  final ThemeData themeData = ThemeData(
    fontFamily: 'Kanit',
    primaryColor: Style.primaryColor,
    accentColor: Style.primaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sodium',
      theme: themeData,
      home: MainScreen(),
      routes: {
        LoginScreen.route: (_) => LoginScreen(),
        RegisterScreen.route: (_) => RegisterScreen(),
        FoodSearchScreen.route: (_) => FoodSearchScreen(),
        FoodAddScreen.route: (_) => FoodAddScreen(),
      },
    );
  }
}
