import 'package:sodium/data/model/food.dart';

class FoodParser {
  static List<Food> fromFatSecretJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => fromFatSecret(json)).toList();
  }

  static List<Food> fromEntryJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => fromEntry(json)).toList();
  }

  static Food fromEntry(dynamic json) {
    final food = json;

    return Food.fromEntry(
      id: food['id'],
      name: food['name'],
      sodium: food['sodium'],
      totalSodium: food['sodium'],
      type: FoodCategory.FatSecret.toString(),
      isLocal: food['is_local'],
      serving: food['serving'],
    );
  }

  static Food fromFatSecret(dynamic json) {
    final food = json;

    return Food(
      id: food['id'],
      name: food['name'],
      isLocal: food['is_local'],
      sodium: food['is_local'] ? food['sodium'] : 0,
      type: food['type'],
      totalSodium: 0,
    );
  }

  static Food fromFatSecretDetail(dynamic json) {
    final _food = json['food'];

    return Food(
      id: int.parse(_food['food_id']),
      name: _food['food_name'],
      unit: 'หน่วย',
      type: FoodCategory.FatSecret.toString(),
      sodium: _parseSodium(_food['servings']['serving']),
      isLocal: false,
    );
  }

  static int _parseSodium(dynamic serving) {
    if (serving[0] != null) {
      return num.parse(serving[0]['sodium']);
    }

    return num.parse(serving['sodium']);
  }
}
