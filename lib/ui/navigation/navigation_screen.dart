import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/achievements/achievements_container.dart';
import 'package:sodium/ui/common/achievement_item.dart';
import 'package:sodium/ui/mental_health/mental_health_container.dart';
import 'package:sodium/ui/mental_health_survey/mental_health_survey_container.dart';
import 'package:sodium/ui/overview/overview_container.dart';
import 'package:sodium/ui/stats/stats_container.dart';
import 'package:sodium/utils/date_time_util.dart';

class NavigationScreen extends StatefulWidget {
  final NavigationViewModel viewModel;

  NavigationScreen({this.viewModel});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> _children;
  int _currentIndex = 0;

  void _showAchievementUnlocked(List<Achievement> achievements) {
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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

  void _showMentalHealthDialog() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) {
        return MentalHealthSurveyContainer();
      },
      fullscreenDialog: true,
    ));
  }

  @override
  void initState() {
    widget.viewModel.achievements.listen((List<Achievement> achievements) {
      if (achievements.isNotEmpty) {
        _showAchievementUnlocked(achievements);
      }
    });

    widget.viewModel.mentalHealthsStream.listen((List<MentalHealth> mentalHealths) {
      final todayMentalHealths = mentalHealths.where((MentalHealth mentalHealth) => isSameDate(mentalHealth.datetime, DateTime.now())).toList();

      if (todayMentalHealths.isEmpty) {
        _showMentalHealthDialog();
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
    _children = [
      OverviewContainer(),
      StatsContainer(),
      MentalHealthContainer(),
      AchievementsContainer(),
      Text('me'),
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.redAccent,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => _setPage(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(AssetIcon.salt, color: Colors.grey.shade400, size: 22.0),
            activeIcon: Icon(AssetIcon.salt, color: Theme.of(context).primaryColor, size: 22.0),
            title: Text('ภาพรวม', style: TextStyle(color: _currentIndex == 0 ? Theme.of(context).primaryColor : Colors.grey)),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartBar, color: Colors.grey.shade400, size: 18.0),
            title: Text('สถิติ', style: TextStyle(color: _currentIndex == 1 ? Theme.of(context).primaryColor : Colors.grey)),
            activeIcon: Icon(FontAwesomeIcons.chartBar, color: Theme.of(context).primaryColor, size: 18.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.smile, color: Colors.grey.shade400, size: 18.0),
            title: Text('สุขภาพใจ', style: TextStyle(color: _currentIndex == 2 ? Theme.of(context).primaryColor : Colors.grey)),
            activeIcon: Icon(FontAwesomeIcons.smile, color: Theme.of(context).primaryColor, size: 18.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.trophy, color: Colors.grey.shade400, size: 18.0),
            activeIcon: Icon(FontAwesomeIcons.trophy, color: Theme.of(context).primaryColor, size: 18.0),
            title: Text('ความสำเร็จ', style: TextStyle(color: _currentIndex == 3 ? Theme.of(context).primaryColor : Colors.grey)),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user, color: Colors.grey.shade400, size: 18.0),
            activeIcon: Icon(FontAwesomeIcons.user, color: Theme.of(context).primaryColor, size: 18.0),
            title: Text('ฉัน', style: TextStyle(color: _currentIndex == 4 ? Theme.of(context).primaryColor : Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class NavigationViewModel {
  BehaviorSubject<List<Achievement>> achievements;
  BehaviorSubject<List<MentalHealth>> mentalHealthsStream;

  NavigationViewModel({
    this.achievements,
    this.mentalHealthsStream,
  });

  static NavigationViewModel fromStore(Store<AppState> store) {
    return NavigationViewModel(
      achievements: store.state.achievementsRecentlyUnlocked,
      mentalHealthsStream: store.state.mentalHealthsStream,
    );
  }
}
