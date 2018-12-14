import 'dart:ui';

import 'package:flutter/material.dart';

class Style {
  static TextStyle description = TextStyle(fontSize: 16.0, color: Colors.grey);
  static TextStyle descriptionPrimary = TextStyle(fontSize: 16.0, color: Palette.primary);

  static TextStyle title = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.grey.shade800, fontFamily: 'Kanit');
  static TextStyle titlePrimary = title.copyWith(color: Palette.primary);

  static TextStyle tileTitle = TextStyle(fontSize: 18.0, color: Colors.grey.shade800);
  static TextStyle tileSubtitle = TextStyle(fontSize: 14.0, color: Colors.grey.shade500);
  static TextStyle tileTrailing = TextStyle(fontSize: 16.0, color: Colors.grey.shade500);
}

class Palette {
  static final Color primary = Color(0xFF00CB7B);
  static final Color highlight = Colors.redAccent.shade400;

  static final Color sad = Color(0xFFFF4641);
  static final Color meh = Colors.purple;
  static final Color smile = Colors.orange;
  static final Color smileBeam = Colors.green;

  static final Color shimmer = Colors.grey.shade200;
  static final Color shimmerHighlight = Colors.grey.shade100;

  static final Color shimmerDark = Colors.blueGrey.shade100;
  static final Color shimmerDarkHighlight = Colors.blueGrey.shade50;
}
