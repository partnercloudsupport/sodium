import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/metal.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 3,
//    backgroundColor: "#000000",
//    textColor: '#ffffff',
  );
}

void popBottomSheet(BuildContext context) {
  Navigator.of(context).pop();
}

void popDialog(BuildContext context) {
  Navigator.of(context).pop();
}

void popLoading(BuildContext context) {
  Navigator.of(context).pop();
}

void popScreen(BuildContext context) {
  Navigator.of(context).pop();
}

Widget buildAppbar(String title) {
  return AppBar(
    centerTitle: true,
    title: Text(title),
    elevation: 2.5,
  );
}

IconData mentalLevelToIconData(int level) {
  if (level == MentalHealth.levelSad) {
    return FontAwesomeIcons.sadTear;
  } else if (level == MentalHealth.levelMeh) {
    return FontAwesomeIcons.meh;
  } else if (level == MentalHealth.levelSmile) {
    return FontAwesomeIcons.smile;
  } else if (level == MentalHealth.levelSmileBeam) {
    return FontAwesomeIcons.smileBeam;
  }

  return FontAwesomeIcons.smileBeam;
}

Icon mentalLevelToIcon(int level) {
  if (level == MentalHealth.levelSad) {
    return Icon(
      FontAwesomeIcons.sadTear,
      color: Palette.sad,
      size: 35.0,
    );
  } else if (level == MentalHealth.levelMeh) {
    return Icon(
      FontAwesomeIcons.meh,
      color: Palette.meh,
      size: 35.0,
    );
  } else if (level == MentalHealth.levelSmile) {
    return Icon(
      FontAwesomeIcons.smile,
      color: Palette.smile,
      size: 35.0,
    );
  } else if (level == MentalHealth.levelSmileBeam) {
    return Icon(
      FontAwesomeIcons.smileBeam,
      color: Palette.smileBeam,
      size: 35.0,
    );
  }

  return Icon(FontAwesomeIcons.smileBeam);
}

Color mentalLevelToColor(int level) {
  if (level == MentalHealth.levelSad) {
    return Palette.sad;
  } else if (level == MentalHealth.levelMeh) {
    return Palette.meh;
  } else if (level == MentalHealth.levelSmile) {
    return Palette.smile;
  } else if (level == MentalHealth.levelSmileBeam) {
    return Palette.smileBeam;
  }

  return Palette.smileBeam;
}
