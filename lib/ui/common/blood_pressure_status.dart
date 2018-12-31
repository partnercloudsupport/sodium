import 'package:flutter/material.dart';
import 'package:sodium/constant/styles.dart';

class BloodPressureLevelBadge extends StatelessWidget {
  final BloodPressureLevel status;

  BloodPressureLevelBadge({
    this.status,
  });

  static BloodPressureLevel systolicValueToStatus(int value) {
    if (value < 120) {
      return BloodPressureLevel.ideal;
    } else if (value > 120 && value < 140) {
      return BloodPressureLevel.elevated;
    } else {
      return BloodPressureLevel.high;
    }
  }

  static BloodPressureLevel diastolicValueToStatus(int value) {
    if (value < 80) {
      return BloodPressureLevel.ideal;
    } else if (value > 80 && value < 99) {
      return BloodPressureLevel.elevated;
    } else {
      return BloodPressureLevel.high;
    }
  }

  String statusToLabel(BloodPressureLevel status) {
    switch (status) {
      case BloodPressureLevel.ideal:
        return 'ideal';
      case BloodPressureLevel.elevated:
        return 'evalated';
      case BloodPressureLevel.high:
        return 'high';
    }

    return 'high';
  }

  Color statusToColor(BloodPressureLevel status) {
    switch (status) {
      case BloodPressureLevel.ideal:
        return Palette.normal;
      case BloodPressureLevel.elevated:
        return Palette.elevated;
      case BloodPressureLevel.high:
        return Palette.high;
    }

    return Palette.high;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: statusToColor(status)),
      ),
      child: Text(
        statusToLabel(status).toUpperCase(),
        style: TextStyle(
          color: statusToColor(status),
        ),
      ),
    );
  }
}

enum BloodPressureLevel {
  ideal,
  elevated,
  high,
}
