import 'dart:io';

import 'package:meta/meta.dart';
import 'package:sodium/utils/string_util.dart';

class Food {
  final int id;
  final String name;
  final double sodium;
  final String unit;
  final String category;
  final double totalSodium;
  final int wholeAmount;
  final double fractionAmount;
  final Uri imageUri;
  final File imageFile;

  Food.fatSecretList({
    @required this.id,
    @required this.name,
    this.unit,
    this.category,
    this.sodium,
    this.totalSodium,
    this.wholeAmount,
    this.fractionAmount,
    this.imageUri,
    this.imageFile,
  });

  Food({
    @required this.id,
    @required this.sodium,
    @required this.name,
    @required this.unit,
    @required this.category,
    this.totalSodium,
    this.wholeAmount,
    this.fractionAmount,
    this.imageUri,
    this.imageFile,
  });

  Food fromAddFood({
    @required double totalCarb,
    @required int wholeAmount,
    @required double fractionAmount,
    @required Uri imageUri,
    @required File imageFile,
  }) {
    return this.copyWith(
      totalCarb: totalCarb,
      wholeAmount: wholeAmount,
      fractionAmount: fractionAmount,
      imageUri: imageUri,
      imageFile: imageFile,
    );
  }

  Food copyWith({
    int id,
    String name,
    double sodium,
    String unit,
    String category,
    double totalCarb,
    int wholeAmount,
    double fractionAmount,
    Uri imageUri,
    File imageFile,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      sodium: sodium ?? this.sodium,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      totalSodium: totalCarb ?? this.totalSodium,
      wholeAmount: wholeAmount ?? this.wholeAmount,
      fractionAmount: fractionAmount ?? this.fractionAmount,
      imageUri: imageUri ?? this.imageUri,
      imageFile: imageFile,
    );
  }

  String getAmountText() {
    if (this.fractionAmount == 0.0) {
      return '${this.wholeAmount}';
    } else {
      return '${this.wholeAmount} กับ ${fractionDoubleToText(this.fractionAmount)}';
    }
  }

  @override
  String toString() {
    return 'Food{id: $id, name: $name, sodium: $sodium, unit: $unit, category: $category, totalCarb: $totalSodium, wholeAmount: $wholeAmount, fractionAmount: $fractionAmount, imageUri: $imageUri, imageFile: $imageFile}';
  }
}

enum FoodCategory {
  FatSecret,
  Local,
  Homemade,
}
