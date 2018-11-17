import 'package:meta/meta.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String token;
  final bool isAdmin;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.token,
    this.isAdmin = false,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, token: $token, isAdmin: $isAdmin}';
  }

  User.register({
    this.id,
    @required this.name,
    @required this.email,
    @required this.password,
    this.token,
    this.isAdmin = false,
  });

  User copyWith({
    String id,
    String name,
    String email,
    String password,
    String token,
    bool isAdmin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
