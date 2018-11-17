import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sodium/data/model/user.dart';

class LoginEvent {
  final String email;
  final String password;
  final Completer<Null> completer;

  LoginEvent({
    @required this.email,
    @required this.password,
    this.completer,
  });
}

class RegisterEvent {
  final User user;
  final Completer<Null> completer;

  RegisterEvent({
    @required this.user,
    this.completer,
  });
}
