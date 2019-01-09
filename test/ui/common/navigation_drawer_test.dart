import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/ui/common/navigation_drawer.dart';
import 'package:test_api/test_api.dart';

void main() {
  group('Navigation drawer test', () {
    testWidgets('Should see user detail in header of drawer', (WidgetTester tester) async {
      final user = User(name: 'John doe', email: 'johndoe@gmail.com');

      tester.pumpWidget(MaterialApp(
        home: NavigationDrawer(
            // user: user,
            ),
      ));
    });
  });
}
