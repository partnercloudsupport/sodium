import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle description = TextStyle(fontSize: 16.0, color: Colors.grey);
TextStyle descriptionPrimary = TextStyle(fontSize: 16.0, color: Style.primaryColor);

TextStyle title = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.grey.shade800);
TextStyle titlePrimary = title.copyWith(color: Style.primaryColor);

TextStyle tileTitle = TextStyle(fontSize: 18.0, color: Colors.grey.shade800);
TextStyle tileSubtitle = TextStyle(fontSize: 14.0, color: Colors.grey.shade500);
TextStyle tileTrailing = TextStyle(fontSize: 16.0, color: Colors.grey.shade500);

class Style {
  static final Color primaryColor = Color(0xFF00CB7B);
  static final Color highlightColor = Colors.redAccent.shade400;

  static final Color sadColor = Color(0xFFFF4641);
  static final Color mehColor = Colors.purple;
  static final Color smileColor = Colors.orange;
  static final Color smileBeamColor = Colors.green;
}
