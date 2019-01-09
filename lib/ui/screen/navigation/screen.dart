import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sodium/constant/key.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/achievement/achievement_item.dart';
import 'package:sodium/ui/common/navigation_drawer.dart';
import 'package:sodium/ui/model/navigation_item.dart';
import 'package:sodium/ui/screen/mental_health_survey/container.dart';
import 'package:sodium/ui/screen/user_info_step/user_info_step_screen.dart';
import 'package:sodium/utils/date_time_util.dart';

class NavigationScreen extends StatefulWidget {
  final NavigationViewModel viewModel;
  final List<NavigationItemModel> navigationItems;

  NavigationScreen({
    this.viewModel,
    @required this.navigationItems,
  });

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> _children;
  int _currentIndex = 0;

  void _showNewAchievementUnlocked(List<Achievement> achievements) {
    Widget achievementItem;

    if (achievements.length > 1) {
      achievementItem = Container();
    } else {
      achievementItem = AchievementItem(
        label: achievements[0].name,
        achieved: true,
      );
    }

    final dialog = SimpleDialog(
      title: Text('คุณได้รับความสำเร็จใหม่', textAlign: TextAlign.center),
      children: <Widget>[
        achievementItem,
        SizedBox(height: 8.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยืนยัน', style: TextStyle(color: Colors.white)),
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

  void _showMentalHealthInputDialog() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => MentalHealthSurveyContainer(),
      fullscreenDialog: true,
    ));
  }

  void _showUserInfoStepInput() {
    Navigator.of(context).pushReplacementNamed(UserInfoStepScreen.route);
  }

  @override
  void initState() {
    widget.viewModel.newAchievementUnlockedStream.listen((List<Achievement> achievements) {
      if (achievements.isNotEmpty) {
        _showNewAchievementUnlocked(achievements);
      }
    });

    widget.viewModel.mentalHealthsStream.listen((List<MentalHealth> mentalHealths) {
      final todayMentalHealths = mentalHealths.where((MentalHealth mentalHealth) => isSameDate(mentalHealth.datetime, DateTime.now())).toList();

      if (todayMentalHealths.isEmpty) {
        _showMentalHealthInputDialog();
      }
    });

    widget.viewModel.userStream.listen((User user) {
      if (user.isNewUser) {
        _showUserInfoStepInput();
      }
    });

    super.initState();
  }

  void _setPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _children = widget.navigationItems
        .map(
          (navigation) => navigation.widget,
        )
        .toList();

    return Scaffold(
      drawer: Drawer(
        key: navigationDrawerKey,
        child: NavigationDrawer(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.navigationItems[_currentIndex].title),
        elevation: 0.3,
      ),
      body: _children.isNotEmpty ? _children[_currentIndex] : Container(),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.redAccent,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => _setPage(index),
        items: widget.navigationItems
            .map(
              (navigation) => BottomNavigationBarItem(
                    icon: navigation.bottomNavigationBarIcon,
                    activeIcon: navigation.bottomNavigationBarActiveIcon,
                    title: navigation.bottomNavigationBarTitle,
                  ),
            )
            .toList(),
      ),
    );
  }
}

class NavigationViewModel {
  BehaviorSubject<List<Achievement>> newAchievementUnlockedStream;
  BehaviorSubject<List<MentalHealth>> mentalHealthsStream;
  BehaviorSubject<User> userStream;
  User user;

  NavigationViewModel({
    this.newAchievementUnlockedStream,
    this.mentalHealthsStream,
    this.userStream,
    this.user,
  });

  static NavigationViewModel fromStore(Store<AppState> store) {
    return NavigationViewModel(
      newAchievementUnlockedStream: store.state.achievementsRecentlyUnlockedStream,
      mentalHealthsStream: store.state.mentalHealthsStream,
      userStream: store.state.userStream,
      user: store.state.user,
    );
  }
}
