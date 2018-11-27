import 'package:meta/meta.dart';

class MentalHealth {
  static const int levelSad = 1;
  static const int levelMeh = 2;
  static const int levelSmile = 3;
  static const int levelSmileBeam = 4;

  final int id;
  final DateTime datetime;
  final int level;

  MentalHealth({
    this.id,
    this.datetime,
    @required this.level,
  });

  @override
  String toString() {
    return 'MentalHealth{id: $id, datetime: $datetime, level: $level}';
  }
}
