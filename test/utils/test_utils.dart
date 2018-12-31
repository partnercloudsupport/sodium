import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

enterTextFormField(WidgetTester tester, Key key, [String text = '']) async {
  final field = find.byKey(key);

  await tester.enterText(field, text);
  await tester.pump();
}
