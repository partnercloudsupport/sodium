import 'package:sodium/data/model/user.dart';

class UserParser {
  static User parse(dynamic json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      token: json['token'] ?? null,
      isAdmin: json['is_admin'],
      sodiumLimit: json['sodium_limit'],
    );
  }
}
