import 'package:sodium/data/model/metal.dart';
import 'package:sodium/utils/date_time_util.dart';

class MentalHealthParser {
  static List<MentalHealth> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => fromJson(json)).toList();
  }

  static MentalHealth fromJson(dynamic json) {
    return MentalHealth(
      id: json['id'],
      level: json['level'],
      datetime: fromMysqlDateTime(json['date_time']),
    );
  }
}
