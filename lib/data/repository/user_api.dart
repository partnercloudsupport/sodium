import 'dart:convert';

import 'package:http/http.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/data/parser/user_parser.dart';

class UserApi {
  final Client client;

  UserApi(this.client);

  Future<User> login() async {
    final response = await client.post(
      'http://192.168.2.106/api/login',
      body: {'user': 'user'},
    );

    if (response.statusCode == 200) {
      return UserParser.parse(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Post> fetchPost() async {
    final response = await client.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
