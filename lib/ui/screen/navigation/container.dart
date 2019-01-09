import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/ui/model/navigation_item.dart';
import 'package:sodium/ui/screen/achievements/container.dart';
import 'package:sodium/ui/screen/entry_stats/container.dart';
import 'package:sodium/ui/screen/mental_health_stats/container.dart';
import 'package:sodium/ui/screen/navigation/screen.dart';
import 'package:sodium/ui/screen/news_list/news_list_container.dart';
import 'package:sodium/ui/screen/overview/container.dart';

class NavigationContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: NavigationViewModel.fromStore,
      builder: (BuildContext context, NavigationViewModel viewModel) {
        return NavigationScreen(
          viewModel: viewModel,
          navigationItems: [
            NavigationItemModel(
              title: 'ภาพรวม',
              widget: OverviewContainer(),
              bottomNavigationBarIcon: Icon(FontAwesomeIcons.chartArea, color: Colors.grey.shade400, size: 18.0),
              bottomNavigationBarActiveIcon: Icon(FontAwesomeIcons.chartArea, color: Theme.of(context).primaryColor, size: 18.0),
              bottomNavigationBarTitle: Text('ภาพรวม', style: TextStyle(color: Colors.grey)),
            ),
            NavigationItemModel(
              title: 'สถิติ',
              widget: EntryStatsContainer(),
              bottomNavigationBarIcon: Icon(AssetIcon.salt, color: Colors.grey.shade400, size: 18.0),
              bottomNavigationBarActiveIcon: Icon(AssetIcon.salt, color: Theme.of(context).primaryColor, size: 18.0),
              bottomNavigationBarTitle: Text('โซเดียม', style: TextStyle(color: Colors.grey)),
            ),
            NavigationItemModel(
              title: 'สุขภาพจิต',
              widget: MentalHealthContainer(),
              bottomNavigationBarIcon: Icon(FontAwesomeIcons.smile, color: Colors.grey.shade400, size: 18.0),
              bottomNavigationBarActiveIcon: Icon(FontAwesomeIcons.smile, color: Theme.of(context).primaryColor, size: 18.0),
              bottomNavigationBarTitle: Text('สุขภาพจิต', style: TextStyle(color: Colors.grey)),
            ),
            NavigationItemModel(
              title: 'ความสำเร็จ',
              widget: AchievementsContainer(),
              bottomNavigationBarIcon: Icon(FontAwesomeIcons.trophy, color: Colors.grey.shade400, size: 18.0),
              bottomNavigationBarActiveIcon: Icon(FontAwesomeIcons.trophy, color: Theme.of(context).primaryColor, size: 18.0),
              bottomNavigationBarTitle: Text('ความสำเร็จ', style: TextStyle(color: Colors.grey)),
            ),
            NavigationItemModel(
              title: 'ข่าวสาร',
              widget: NewsListContainer(),
              bottomNavigationBarIcon: Icon(FontAwesomeIcons.newspaper, color: Colors.grey.shade400, size: 22.0),
              bottomNavigationBarActiveIcon: Icon(FontAwesomeIcons.newspaper, color: Theme.of(context).primaryColor, size: 22.0),
              bottomNavigationBarTitle: Text('ข่าวสาร', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
