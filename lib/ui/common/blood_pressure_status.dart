import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';

class BloodPressureLevelBadge extends StatelessWidget {
  final BloodPressureLevel status;

  BloodPressureLevelBadge({
    this.status,
  });

  static BloodPressureLevel systolicValueToStatus(int value) {
    if (value >= 180) {
      return BloodPressureLevel.severe;
    } else if (value > 160) {
      return BloodPressureLevel.moderate;
    } else if (value > 140) {
      return BloodPressureLevel.mild;
    } else if (value > 130) {
      return BloodPressureLevel.highNormal;
    } else {
      return BloodPressureLevel.normal;
    }
  }

  static BloodPressureLevel diastolicValueToStatus(int value) {
    if (value >= 110) {
      return BloodPressureLevel.severe;
    } else if (value > 100) {
      return BloodPressureLevel.moderate;
    } else if (value > 90) {
      return BloodPressureLevel.mild;
    } else if (value > 85) {
      return BloodPressureLevel.highNormal;
    } else {
      return BloodPressureLevel.normal;
    }
  }

  String statusToLabel(BloodPressureLevel status) {
    switch (status) {
      case BloodPressureLevel.normal:
        return 'normal';
      case BloodPressureLevel.highNormal:
        return 'high normal';
      case BloodPressureLevel.mild:
        return 'mild';
      case BloodPressureLevel.moderate:
        return 'moderate';
      case BloodPressureLevel.severe:
        return 'severe';
    }

    return 'severe';
  }

  Color statusToColor(BloodPressureLevel status) {
    switch (status) {
      case BloodPressureLevel.normal:
        return Palette.normal;
      case BloodPressureLevel.highNormal:
        return Palette.normal;
      case BloodPressureLevel.mild:
        return Palette.high;
      case BloodPressureLevel.moderate:
        return Palette.high;
      case BloodPressureLevel.severe:
        return Palette.high;
    }

    return Palette.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.all(Radius.circular(4)),
//        border: Border.all(color: statusToColor(status)),
//      ),
      child: Text(
        statusToLabel(status).toUpperCase(),
        style: TextStyle(color: statusToColor(status), fontWeight: FontWeight.w400),
      ),
    );
  }
}

enum BloodPressureLevel {
  normal,
  highNormal,
  mild,
  moderate,
  severe,
}
