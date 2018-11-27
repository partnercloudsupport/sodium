import 'package:sodium/data/model/food.dart';
import 'package:sodium/utils/date_time_util.dart';

class FoodParser {
  static List<Food> fromSearchJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => fromSearch(json)).toList();
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
      totalSodium: food['total_sodium'],
      type: food['type'],
      isLocal: food['is_local'],
      serving: food['serving'],
      dateTime: fromMysqlDateTime(food['date_time']),
    );
  }

  static Food fromSearch(dynamic json) {
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
      type: 'อาหารทั่วไป',
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
