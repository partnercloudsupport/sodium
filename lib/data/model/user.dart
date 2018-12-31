import 'package:meta/meta.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final int sodiumLimit;
  final String token;
  final bool isAdmin;
  final DateTime dateOfBirth;
  final String healthCondition;
  final String gender;
  final bool isNewUser;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.sodiumLimit = 2400,
    this.token,
    this.isAdmin = false,
    this.dateOfBirth,
    this.healthCondition,
    this.gender,
    this.isNewUser,
  });

  String toJson() {
    return 'User{id: $id, name: $name, email: $email, password: $password, sodiumLimit: $sodiumLimit, token: $token, isAdmin: $isAdmin}';
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, sodiumLimit: $sodiumLimit, isAdmin: $isAdmin, dateOfBirth: $dateOfBirth, healthCondition: $healthCondition, gender: $gender, isNewUser: $isNewUser}';
  }

  User.register({
    @required this.name,
    @required this.email,
    @required this.password,
    this.sodiumLimit = 2400,
    this.id,
    this.token,
    this.isAdmin = false,
    this.dateOfBirth,
    this.healthCondition,
    this.gender,
    this.isNewUser = false,
  });

  User copyWith({
    String id,
    String name,
    String email,
    String password,
    int sodiumLimit,
    String token,
    bool isAdmin,
    DateTime dateOfBirth,
    String healthCondition,
    String gender,
    bool isNewUser,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      sodiumLimit: sodiumLimit ?? this.sodiumLimit,
      token: token ?? this.token,
      isAdmin: isAdmin ?? this.isAdmin,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      healthCondition: healthCondition ?? this.healthCondition,
      gender: gender ?? this.gender,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
