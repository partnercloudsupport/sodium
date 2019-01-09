import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/ui/common/navigation/navigation_item.dart';
import 'package:sodium/ui/common/section/section_divider.dart';
import 'package:sodium/ui/screen/about/about_screen.dart';
import 'package:sodium/ui/screen/blood_pressure_section/blood_pressure_screen.dart';
import 'package:sodium/ui/screen/profile/profile_screen.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Natthapon Sricort'),
                subtitle: Text('natthaponsricort@gmail.com'),
              ),
              SectionDivider(),
              NavigationTile(
                icon: FontAwesomeIcons.heartbeat,
                title: 'บันทึกความดันโลหิต',
                onTap: () => Navigator.of(context).pushNamed(BloodPressureScreen.route),
              ),
              NavigationTile(
                icon: FontAwesomeIcons.cog,
                title: 'ตั้งค่า',
                onTap: () => Navigator.of(context).pushNamed(ProfileScreen.route),
              ),
            ],
          ),
        ),
        NavigationTile(
          icon: FontAwesomeIcons.infoCircle,
          title: 'เกี่ยวกับ',
          onTap: () => Navigator.of(context).pushNamed(AboutScreen.route),
        )
      ],
    );
  }
}
