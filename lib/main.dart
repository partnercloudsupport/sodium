import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/redux/app/app_action.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/store.dart';
import 'package:sodium/ui/screen/about/about_screen.dart';
import 'package:sodium/ui/screen/blood_pressure_section/blood_pressure_screen.dart';
import 'package:sodium/ui/screen/blood_pressure_section/blood_pressure_section_container.dart';
import 'package:sodium/ui/screen/food_search/container.dart';
import 'package:sodium/ui/screen/food_search/screen.dart';
import 'package:sodium/ui/screen/food_user_add/container.dart';
import 'package:sodium/ui/screen/food_user_add/screen.dart';
import 'package:sodium/ui/screen/login/screen.dart';
import 'package:sodium/ui/screen/main/container.dart';
import 'package:sodium/ui/screen/main/screen.dart';
import 'package:sodium/ui/screen/news_compose/news_add_container.dart';
import 'package:sodium/ui/screen/news_compose/news_compose_screen.dart';
import 'package:sodium/ui/screen/overview/container.dart';
import 'package:sodium/ui/screen/overview/screen.dart';
import 'package:sodium/ui/screen/profile/profile_container.dart';
import 'package:sodium/ui/screen/profile/profile_screen.dart';
import 'package:sodium/ui/screen/register/register_container.dart';
import 'package:sodium/ui/screen/register/register_screen.dart';
import 'package:sodium/ui/screen/splash/splash_screen.dart';
import 'package:sodium/ui/screen/user_info_step/user_info_step_container.dart';
import 'package:sodium/ui/screen/user_info_step/user_info_step_screen.dart';

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
        showSemanticsDebugger: false,
        title: 'Mind Sodium',
        theme: themeData,
        home: SplashScreen(),
        routes: {
          MainScreen.route: (_) => MainContainer(),
          OverviewScreen.route: (_) => OverviewContainer(),
          LoginScreen.route: (_) => LoginScreen(),
          RegisterScreen.route: (_) => RegisterScreen(),
          FoodSearchScreen.route: (_) => FoodSearchContainer(),
          MyFoodAddScreen.route: (_) => MyFoodAddContainer(),
          NewsComposeScreen.route: (_) => NewsComposeContainer(),
          ProfileScreen.route: (_) => ProfileContainer(),
          RegisterScreen.route: (_) => RegisterContainer(),
          UserInfoStepScreen.route: (_) => UserStepInfoContainer(),
          BloodPressureScreen.route: (_) => BloodPressureContainer(),
          SplashScreen.route: (_) => SplashScreen(),
          AboutScreen.route: (_) => AboutScreen()
        },
      ),
    );
  }
}
