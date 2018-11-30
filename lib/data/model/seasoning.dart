import 'package:sodium/data/model/unit.dart';

class Seasoning {
  final int id;
  final String name;
  final int sodiumPerTeaspoon;
  final Unit unit;
  final double selectedAmount;
  final int totalSodium;

  Seasoning({
    this.id,
    this.name,
    this.sodiumPerTeaspoon,
    this.unit,
    this.selectedAmount,
    this.totalSodium,
  });

  Seasoning copyWith({
    final int id,
    final String name,
    final int sodiumPerTeaspoon,
    final Unit unit,
    final double selectedAmount,
    final int totalSodium,
  }) {
    return Seasoning(
      id: id ?? this.id,
      name: name ?? this.name,
      sodiumPerTeaspoon: sodiumPerTeaspoon ?? this.sodiumPerTeaspoon,
      unit: unit ?? this.unit,
      selectedAmount: selectedAmount ?? this.selectedAmount,
      totalSodium: totalSodium ?? this.totalSodium,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Seasoning && runtimeType == other.runtimeType && id == other.id && name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Seasoning{id: $id, name: $name, sodiumPerTeaspoon: $sodiumPerTeaspoon, unit: $unit, selectedAmount: $selectedAmount, totalSodium: $totalSodium}';
  }
}
