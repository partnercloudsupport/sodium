import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/redux/app/app_action.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/store.dart';
import 'package:sodium/ui/screen/food_search/container.dart';
import 'package:sodium/ui/screen/food_search/screen.dart';
import 'package:sodium/ui/screen/login/screen.dart';
import 'package:sodium/ui/screen/main/container.dart';
import 'package:sodium/ui/screen/overview/container.dart';
import 'package:sodium/ui/screen/overview/screen.dart';
import 'package:sodium/ui/screen/register_screen.dart';

void main() async {
  final store = await createStore();

  runApp(SodiumApp(store: store));
}

class SodiumApp extends StatefulWidget {
  SodiumApp({this.store});

  final Store<AppState> store;

  @override
  SodiumAppState createState() {
    return SodiumAppState();
  }
}

class SodiumAppState extends State<SodiumApp> {
  final ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Kanit',
    primaryColor: Palette.primary,
    accentColor: Palette.primary,
    accentIconTheme: IconThemeData(color: Colors.white),
    primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
    accentTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
    tabBarTheme: TabBarTheme(labelColor: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.white),
  );

  @override
  void initState() {
    super.initState();

    widget.store.dispatch(Init());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MaterialApp(
        title: 'Sodium',
        theme: themeData,
        home: MainContainer(),
        routes: {
          OverviewScreen.route: (_) => OverviewContainer(),
          LoginScreen.route: (_) => LoginScreen(),
          RegisterScreen.route: (_) => RegisterScreen(),
          FoodSearchScreen.route: (_) => FoodSearchContainer(),
        },
      ),
    );
  }
}
