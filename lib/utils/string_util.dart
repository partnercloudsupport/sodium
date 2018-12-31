import 'package:intl/intl.dart';

String toBearer(String token) {
  return 'Bearer $token';
}

bool isEmail(String em) {
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(em);
}

String mysqlDateTimeFormat = 'yyyy-MM-dd hh:mm:ss';

String toMysqlDateTime(DateTime datetime) {
  DateFormat formatter = DateFormat(mysqlDateTimeFormat);
  return formatter.format(datetime);
}

DateTime fromMysqlDateTime(String datetime) {
  DateFormat formatter = DateFormat(mysqlDateTimeFormat);
  return formatter.parse(datetime);
}

String toThaiDate(DateTime datetime, [String format = 'dd MMM yyyy']) {
  final formatter = DateFormat(format, 'th_TH');
  return formatter.format(datetime);
}

String getFirstCharacter(String text) {
  return text[0];
}

double fractionTextToDouble(String fraction) {
  switch (fraction) {
    case '0':
      return 0.0;
    case '1/8':
      return 0.125;
    case '1/4':
      return 0.25;
    case '1/3':
      return 0.33;
    case '3/8':
      return 0.375;
    case '1/2':
      return 0.5;
    case '5/8':
      return 0.625;
    case '2/3':
      return 0.66;
    case '3/4':
      return 0.75;
    case '7/8':
      return 0.875;
  }
}

String decimalToFraction(num fraction) {
  if (fraction >= 1) return fraction.toInt().toString();

  if (fraction == 0.0)
    return '0';
  else if (fraction == 0.125)
    return '1/8';
  else if (fraction == 0.25)
    return '1/4';
  else if (fraction == 0.33)
    return '1/3';
  else if (fraction == 0.375)
    return '3/8';
  else if (fraction == 0.5)
    return '1/2';
  else if (fraction == 0.625)
    return '5/8';
  else if (fraction == 0.66)
    return '2/3';
  else if (fraction == 0.75)
    return '3/4';
  else if (fraction == 0.875) return '7/8';
}
