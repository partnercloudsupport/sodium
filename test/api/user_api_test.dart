import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/data/repository/user_api.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

main() {
  test('return User if login successfully', () async {
    final client = MockClient();

    when(client.post('http://192.168.2.106/api/login', body: {'user': 'user'})).thenAnswer(
      (_) async => Response(
            '{"id":4,'
                '"name":"NatthaponSricort",'
                '"email":"user@gmail.com",'
                '"sodium_limit":1800,'
                '"date_of_birth":"1994-01-01 00:00:00",'
                '"gender":"male","health_condition":'
                '"condition",'
                '"is_admin":true,'
                '"is_new_user":true,'
                '"token":"token"'
                '}',
            200,
          ),
    );

    final api = UserApi(client);
    final user = await api.login();

    expect(user, TypeMatcher<User>());
    expect(user.email, 'user@gmail.com');
  });
}
