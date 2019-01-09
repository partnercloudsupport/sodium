import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sodium/constant/key.dart';
import 'package:sodium/ui/model/navigation_item.dart';
import 'package:sodium/ui/screen/navigation/screen.dart';

class MockNavigationViewModel extends Mock implements NavigationViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Login screen test', () {
    Widget app;
    MockNavigationViewModel mockNavigationViewModel;

    setUp(() {
      mockNavigationViewModel = MockNavigationViewModel();

      when(mockNavigationViewModel.newAchievementUnlockedStream).thenAnswer((_) => BehaviorSubject());
      when(mockNavigationViewModel.mentalHealthsStream).thenAnswer((_) => BehaviorSubject());
      when(mockNavigationViewModel.userStream).thenAnswer((_) => BehaviorSubject());

      app = MaterialApp(
        home: NavigationScreen(
          viewModel: mockNavigationViewModel,
          navigationItems: [
            NavigationItemModel(
              title: 'Page one title',
              widget: Container(key: Key('page_one_key')),
              bottomNavigationBarIcon: Icon(Icons.book),
              bottomNavigationBarTitle: Text('Page one'),
            ),
            NavigationItemModel(
              title: 'Page two title',
              widget: Container(),
              bottomNavigationBarIcon: Icon(Icons.network_wifi),
              bottomNavigationBarTitle: Text('Page two'),
            ),
          ],
        ),
      );
    });

    testWidgets('When drag from the start of screen, should see drawer', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.dragFrom(Offset(0.0, 0.0), Offset(250.0, 0.0));
      await tester.pump();

      expect(find.byKey(navigationDrawerKey), findsOneWidget);
    });

    testWidgets('When click on hambergur button, should see drawer', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();

      expect(find.byKey(navigationDrawerKey), findsOneWidget);
    });

    testWidgets('When provided childrens, should see correct number of bottom navigation bar item', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      expect(find.widgetWithIcon(BottomNavigationBar, Icons.book), findsOneWidget);
      expect(find.widgetWithIcon(BottomNavigationBar, Icons.network_wifi), findsOneWidget);
    });
  });
}
