import 'package:flutter/material.dart';

class NavigationItemModel {
  final String title;
  final Widget widget;
  final Widget bottomNavigationBarTitle;
  final Icon bottomNavigationBarIcon;
  final Icon bottomNavigationBarActiveIcon;

  NavigationItemModel({
    @required this.widget,
    @required this.bottomNavigationBarTitle,
    @required this.bottomNavigationBarIcon,
    this.title,
    this.bottomNavigationBarActiveIcon,
  });
}
