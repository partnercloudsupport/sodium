import 'package:flutter/material.dart';
import 'package:sodium/bloc/application_bloc.dart';
import 'package:sodium/bloc/bloc_provider.dart';
import 'package:sodium/bloc/overview_bloc.dart';
import 'package:sodium/ui/food_search.dart';
import 'package:sodium/ui/login_screen.dart';
import 'package:sodium/ui/main_screen.dart';
import 'package:sodium/ui/register_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData themeData = ThemeData(
    fontFamily: 'Kanit',
    primaryColor: Color(0xFFD0021B),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider<OverviewBloc>(
        bloc: OverviewBloc(),
        child: MaterialApp(
          title: 'Sodium',
          theme: themeData,
          home: MainScreen(),
          routes: {
            LoginScreen.route: (_) => LoginScreen(),
            RegisterScreen.route: (_) => RegisterScreen(),
            FoodSearchScreen.route: (_) => FoodSearchScreen(),
          },
        ),
      ),
    );
  }
}
