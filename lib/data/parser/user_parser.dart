import 'package:sodium/data/model/user.dart';
import 'package:sodium/utils/date_time_util.dart';

class UserParser {
  static User parse(dynamic json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      token: json['token'] ?? null,
      isAdmin: json['is_admin'],
      sodiumLimit: json['sodium_limit'],
      dateOfBirth: json['date_of_birth'] != null ? fromMysqlDateTime(json['date_of_birth']) : null,
      healthCondition: json['health_condition'],
      gender: json['gender'],
      isNewUser: json['is_new_user'],
    );
  }
}
