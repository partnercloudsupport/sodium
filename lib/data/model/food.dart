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
  final DateTime dateTime;

  Food({
    @required this.id,
    @required this.name,
    this.unit,
    this.sodium,
    this.totalSodium,
    this.type,
    this.isLocal,
    this.serving = 1,
    this.dateTime,
  });

  Food.fromEntry({
    @required this.id,
    @required this.name,
    @required this.sodium,
    @required this.totalSodium,
    @required this.type,
    @required this.isLocal,
    @required this.serving,
    @required this.dateTime,
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
    DateTime dateTime,
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
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  String toString() {
    return ' date : $dateTime , total_sodum : $totalSodium , food_id : $id';
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Food && runtimeType == other.runtimeType && id == other.id && name == other.name && unit == other.unit && sodium == other.sodium && totalSodium == other.totalSodium && type == other.type && isLocal == other.isLocal && serving == other.serving && dateTime == other.dateTime;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ unit.hashCode ^ sodium.hashCode ^ totalSodium.hashCode ^ type.hashCode ^ isLocal.hashCode ^ serving.hashCode ^ dateTime.hashCode;
}

enum FoodCategory {
  FatSecret,
  Thai,
  Homemade,
}
