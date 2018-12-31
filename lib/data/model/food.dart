import 'package:meta/meta.dart';
import 'package:sodium/data/model/seasoning.dart';

class Food {
  final int id;
  final int entryId;
  final String name;
  final String unit;
  final int sodium;
  final int totalSodium;
  final String type;
  final bool isLocal;
  final double serving;
  final DateTime dateTime;
  final List<Seasoning> seasonings;

  Food({
    this.id,
    this.entryId,
    @required this.name,
    this.unit,
    this.sodium,
    this.totalSodium,
    this.type,
    this.isLocal,
    this.serving = 1,
    this.dateTime,
    this.seasonings,
  });

  Food.fromEntry({
    @required this.id,
    @required this.entryId,
    @required this.name,
    @required this.sodium,
    @required this.totalSodium,
    @required this.type,
    @required this.isLocal,
    @required this.serving,
    @required this.dateTime,
    @required this.seasonings,
    this.unit,
  });

  Food copyWith({
    int id,
    int entryId,
    String name,
    String unit,
    int sodium,
    int totalSodium,
    String type,
    bool isLocal,
    double serving,
    DateTime dateTime,
    List<Seasoning> seasonings,
  }) {
    return Food(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      sodium: sodium ?? this.sodium,
      totalSodium: totalSodium ?? this.sodium,
      type: type ?? this.type,
      isLocal: isLocal ?? this.isLocal,
      serving: serving ?? this.serving,
      dateTime: dateTime ?? this.dateTime,
      seasonings: seasonings ?? this.seasonings,
    );
  }

  @override
  String toString() {
    return 'Food{id: $id, name: $name, unit: $unit, sodium: $sodium, totalSodium: $totalSodium, type: $type, isLocal: $isLocal, serving: $serving, dateTime: $dateTime, seasonings: $seasonings}';
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
