import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/constant/key.dart';
import 'package:sodium/ui/screen/login/screen.dart';
import 'package:sodium/ui/screen/register/register_screen.dart';

import '../../utils/test_utils.dart';

class MockLoginScreenViewModel extends Mock implements LoginScreenViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Login screen test', () {
    MockLoginScreenViewModel mockLoginScreenViewModel;
    MockNavigatorObserver mockObserver;

    Widget app;

    setUp(() {
      mockLoginScreenViewModel = MockLoginScreenViewModel();
      mockObserver = MockNavigatorObserver();

      app = MaterialApp(
        home: LoginScreen(viewModel: mockLoginScreenViewModel),
        navigatorObservers: [mockObserver],
        routes: {
          RegisterScreen.route: (_) => RegisterScreen(),
        },
      );
    });

    tapLoginButton(WidgetTester tester) async {
      final loginButtonFinder = find.byKey(loginButtonKey);
      await tester.tap(loginButtonFinder);
      await tester.pump();
    }

    tapCreateAccountButton(WidgetTester tester) async {
      final loginCreateAccountButtonFinder = find.byKey(loginCreateAccountButtonKey);
      await tester.tap(loginCreateAccountButtonFinder);
      await tester.pump();
    }

    testWidgets('When email is empty, should see email error text', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      await enterTextFormField(tester, loginPasswordFieldKey, 'password');
      await tapLoginButton(tester);

      expect(find.widgetWithText(TextFormField, 'กรุณากรอกอีเมลล์'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'กรุณากรอกรหัสผ่าน'), findsNothing);
    });

    testWidgets('When password is empty, should see password error text', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      await enterTextFormField(tester, loginEmailFieldKey, 'user@gmail.com');
      await tapLoginButton(tester);

      expect(find.widgetWithText(TextFormField, 'กรุณากรอกอีเมลล์'), findsNothing);
      expect(find.widgetWithText(TextFormField, 'กรุณากรอกรหัสผ่าน'), findsOneWidget);
    });

    testWidgets('When email is invalid, shoud see email error text', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      await enterTextFormField(tester, loginEmailFieldKey, 'usermail.com');
      await enterTextFormField(tester, loginPasswordFieldKey, 'password');

      await tapLoginButton(tester);

      expect(find.widgetWithText(TextFormField, 'รูปแบบอีเมลล์ไม่ถูกต้อง'), findsOneWidget);
    });

    testWidgets('When email and password is fill correctly, should see Loading then call onLogin', (WidgetTester tester) async {
      when(mockLoginScreenViewModel.onLogin).thenReturn((email, password, completer) => null);

      await tester.pumpWidget(app);

      await enterTextFormField(tester, loginEmailFieldKey, 'user@gmail.com');
      await enterTextFormField(tester, loginPasswordFieldKey, 'password');

      await tapLoginButton(tester);

      expect(find.text('กำลังเข้าสู่ระบบ..'), findsOneWidget);
      verify(mockLoginScreenViewModel.onLogin);
    });

    testWidgets('When tap create acount button, should navigate to register screen', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      verify(mockObserver.didPush(any, any));

      await tapCreateAccountButton(tester);
      verify(mockObserver.didPush(any, any));

      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });
}
