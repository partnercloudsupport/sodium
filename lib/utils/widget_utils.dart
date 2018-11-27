import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/metal.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 3,
    bgcolor: "#000000",
    textcolor: '#ffffff',
  );
}

Widget shimmer(double width, double height) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200],
    highlightColor: Colors.grey[50],
    child: Container(
      color: Colors.grey[200],
      height: height,
      width: width,
    ),
  );
}

void hideDialog(BuildContext context) {
  Navigator.of(context).pop();
}

void popScreen(BuildContext context) {
  Navigator.of(context).pop();
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
      color: Style.sadColor,
      size: 35.0,
    );
  } else if (level == MentalHealth.levelMeh) {
    return Icon(
      FontAwesomeIcons.meh,
      color: Style.mehColor,
      size: 35.0,
    );
  } else if (level == MentalHealth.levelSmile) {
    return Icon(
      FontAwesomeIcons.smile,
      color: Style.smileColor,
      size: 35.0,
    );
  } else if (level == MentalHealth.levelSmileBeam) {
    return Icon(
      FontAwesomeIcons.smileBeam,
      color: Style.smileBeamColor,
      size: 35.0,
    );
  }

  return Icon(FontAwesomeIcons.smileBeam);
}

Color mentalLevelToColor(int level) {
  if (level == MentalHealth.levelSad) {
    return Style.sadColor;
  } else if (level == MentalHealth.levelMeh) {
    return Style.mehColor;
  } else if (level == MentalHealth.levelSmile) {
    return Style.smileColor;
  } else if (level == MentalHealth.levelSmileBeam) {
    return Style.smileBeamColor;
  }

  return Style.smileBeamColor;
}
