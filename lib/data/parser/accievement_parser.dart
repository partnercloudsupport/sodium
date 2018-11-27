import 'package:sodium/data/model/acchievement.dart';

class AchievementParser {
  static List<Achievement> fromJsonArray(List<dynamic> jsonArray) {
    final achievements = jsonArray.map((json) => fromJson(json)).toList();

    return achievements;
  }

  static Achievement fromJson(dynamic json) {
    return Achievement(
      id: null,
      points: json['points'],
      unlocked: json['unlocked_at'] != null,
      name: json['name'],
      description: json['description'],
    );
  }
}
