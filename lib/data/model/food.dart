import 'package:meta/meta.dart';

class Food {
  final int id;
  final String name;
  final String unit;
  final int sodium;
  final int totalSodium;
  final String type;
  final bool isLocal;
  final int serving;

  Food({
    @required this.id,
    @required this.name,
    this.unit,
    this.sodium,
    this.totalSodium,
    this.type,
    this.isLocal,
    this.serving = 1,
  });

  Food.fromEntry({
    @required this.id,
    @required this.name,
    @required this.sodium,
    @required this.totalSodium,
    @required this.type,
    @required this.isLocal,
    @required this.serving,
    this.unit,
  });

  Food copyWith({
    int id,
    String name,
    String unit,
    int sodium,
    int totalSodium,
    String type,
    bool isLocal,
    int amount,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      sodium: sodium ?? this.sodium,
      totalSodium: totalSodium ?? this.sodium,
      type: type ?? this.type,
      isLocal: isLocal ?? this.isLocal,
      serving: amount ?? this.serving,
    );
  }

  @override
  String toString() {
    return 'Food{id: $id, name: $name, unit: $unit, sodium: $sodium, totalSodium: $totalSodium, type: $type, isLocal: $isLocal, amount: $serving}';
  }
}

enum FoodCategory {
  FatSecret,
  Thai,
  Homemade,
}
