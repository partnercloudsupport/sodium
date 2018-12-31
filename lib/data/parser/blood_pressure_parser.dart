import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/ui/common/blood_pressure_status.dart';
import 'package:sodium/utils/date_time_util.dart';

class BloodPressureParser {
  static BloodPressure parse(dynamic json) {
    return BloodPressure(
      id: json['id'],
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      systolicLevel: json['systolic'] != null ? BloodPressureLevelBadge.systolicValueToStatus(json['systolic']) : null,
      diastolicLevel: json['diastolic'] != null ? BloodPressureLevelBadge.diastolicValueToStatus(json['diastolic']) : null,
      dateTime: fromMysqlDateTime(json['date_time']),
    );
  }

  static List<BloodPressure> parseArray(List<dynamic> array) {
    return array.map((json) => parse(json)).toList();
  }
}
