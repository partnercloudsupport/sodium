import 'package:sodium/data/model/food.dart';

class FoodParser {
  static List<Food> fromFatSecretJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => parseFatSecretList(json)).toList();
  }

  static Food parseFatSecretList(dynamic json) {
    final _food = json;

    return Food.fatSecretList(
      id: int.parse(_food['food_id']),
      name: _food['food_name'],
      sodium: 0.0,
      totalSodium: 0.0,
    );
  }

  static Food parseFatSecretDetail(dynamic json) {
    final _food = json['food'];

    return Food(
      id: int.parse(_food['food_id']),
      name: _food['food_name'],
      unit: 'หน่วย',
      category: FoodCategory.FatSecret.toString(),
      sodium: 2.0,
      //  sodium: int.parse(_food['servinngs']['serving']['sodium']).toDouble(),
    );
  }
}
