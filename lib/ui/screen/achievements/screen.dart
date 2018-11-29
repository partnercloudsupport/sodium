import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/achievement/achievement_item.dart';
import 'package:sodium/ui/common/loading/loading_shimmer.dart';
import 'package:sodium/ui/common/section/section.dart';

class AchievementsScreen extends StatefulWidget {
  final AchievementsScreenViewModel viewModel;

  AchievementsScreen({
    this.viewModel,
  });

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementsScreen> {
  Widget _buildSodiumBalancingAchievements() {
    final achievementTrophies = widget.viewModel.achievements
        .map(
          (Achievement achievement) => Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: AchievementItem(achieved: achievement.unlocked, label: achievement.description),
              ),
        )
        .toList();

    return Row(
      children: achievementTrophies,
    );
  }

  Widget _buildAchievementsShimmerLoading() {
    return SectionContainer(
      title: Container(),
      body: ShimmerLoading.achievementList(),
    );
  }

  Widget _buildSodiumBalancingSection() {
    return SectionContainer(
      title: Text('รักษาระดับโซเดียมติดต่อกัน', style: title),
      body: Container(
        height: 110.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildSodiumBalancingAchievements(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ความสำเร็จ'),
        elevation: .3,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            widget.viewModel.isLoading ? _buildAchievementsShimmerLoading() : _buildSodiumBalancingSection(),
          ],
        ),
      ),
    );
  }
}

class AchievementsScreenViewModel {
  final List<Achievement> achievements;
  final List<Food> entries;
  final bool isLoading;

  AchievementsScreenViewModel({
    @required this.achievements,
    @required this.entries,
    @required this.isLoading,
  });

  static AchievementsScreenViewModel fromStore(Store<AppState> store) {
    return AchievementsScreenViewModel(
      achievements: store.state.achievements,
      entries: store.state.entries,
      isLoading: store.state.entries == null,
    );
  }
}
