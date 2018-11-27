import 'package:intl/intl.dart';
import 'package:sodium/utils/string_util.dart';

String toMysqlDateTime(DateTime datetime) {
  DateFormat formatter = DateFormat(mysqlDateTimeFormat);
  return formatter.format(datetime);
}

DateTime fromMysqlDateTime(String datetime) {
  DateFormat formatter = DateFormat(mysqlDateTimeFormat);
  return formatter.parse(datetime);
}

bool isSameDate(DateTime datetime, DateTime other) {
  return datetime.day == other.day && datetime.month == other.month && datetime.year == other.year;
}

String toThaiDate(DateTime datetime, [String format = 'dd MMM yyyy']) {
  final formatter = DateFormat(format);
  return formatter.format(datetime);
}

bool isSameMonth(DateTime datetime, DateTime other) {
  return datetime.month == other.month && datetime.year == other.year;
}

bool isSameOrBetweenDate({DateTime datetime, DateTime from, DateTime to}) {
  bool sameDateWithStart = isSameDate(datetime, from);
  bool sameDateWithEnd = isSameDate(datetime, to);
  bool between = datetime.isAfter(from) && datetime.isBefore(to);

  return (sameDateWithStart || sameDateWithEnd) || between;
}
