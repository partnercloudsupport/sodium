import 'package:sodium/data/model/seasoning.dart';

class SeasoningParser {
  static List<Seasoning> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => fromJson(json)).toList();
  }

  static Seasoning fromJson(dynamic json) {
    return Seasoning(
      id: json['id'],
      name: json['name'],
      sodiumPerTeaspoon: json['sodium_per_teaspoon'],
    );
  }
}
