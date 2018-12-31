import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sodium/data/model/loading.dart';
import 'package:sodium/ui/common/loading/loading_container.dart';

main() {
  const loading = Key('test-loading');
  const success = Key('test-success');
  const notFound = Key('test-not-found');
  const error = Key('test-error');
  const initial = Key('test-inital');

  Future<void> _pumpLoadingContainerByStatus(
    LoadingStatus status,
    WidgetTester tester, {
    bool provideSuccessContent = true,
    bool provideErrorContent = true,
    bool provideNotFoundContent = true,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: LoadingContainer(
          loadingStatus: status,
          loadingContent: Container(key: loading),
          initialContent: Container(key: initial),
          successContent: provideSuccessContent ? Container(key: success) : null,
          notFoundContent: provideNotFoundContent ? Container(key: notFound) : null,
          errorContent: provideErrorContent ? Container(key: error) : null,
        ),
      ),
    );
  }

  group('When all paremeter is provided', () {
    testWidgets('When LoadingStatus is equal to loading, should see loading content', (WidgetTester tester) async {
      await _pumpLoadingContainerByStatus(
        LoadingStatus.loading,
        tester,
      );

      expect(find.byKey(loading), findsOneWidget);
      expect(find.byKey(initial), findsNothing);
      expect(find.byKey(success), findsNothing);
      expect(find.byKey(error), findsNothing);
      expect(find.byKey(notFound), findsNothing);
    });

    testWidgets('When LoadingStatus is equal to success, should see success content', (WidgetTester tester) async {
      await _pumpLoadingContainerByStatus(
        LoadingStatus.success,
        tester,
      );

      expect(find.byKey(loading), findsNothing);
      expect(find.byKey(initial), findsNothing);
      expect(find.byKey(success), findsOneWidget);
      expect(find.byKey(error), findsNothing);
      expect(find.byKey(notFound), findsNothing);
    });

    testWidgets('When LoadingStatus is equal to error, should see error content', (WidgetTester tester) async {
      await _pumpLoadingContainerByStatus(
        LoadingStatus.error,
        tester,
      );

      expect(find.byKey(loading), findsNothing);
      expect(find.byKey(initial), findsNothing);
      expect(find.byKey(success), findsNothing);
      expect(find.byKey(error), findsOneWidget);
      expect(find.byKey(notFound), findsNothing);
    });

    testWidgets('When LoadingStatus is equal to notFound, should see notFound content', (WidgetTester tester) async {
      await _pumpLoadingContainerByStatus(
        LoadingStatus.notFound,
        tester,
      );

      expect(find.byKey(loading), findsNothing);
      expect(find.byKey(initial), findsNothing);
      expect(find.byKey(success), findsNothing);
      expect(find.byKey(error), findsNothing);
      expect(find.byKey(notFound), findsOneWidget);
    });
  });

  group('When some paremeter is provided', () {
    testWidgets('When LoadingStatus is equal to success and success content is not provided , should see initial content', (WidgetTester tester) async {
      await _pumpLoadingContainerByStatus(
        LoadingStatus.success,
        tester,
        provideSuccessContent: false,
      );

      expect(find.byKey(loading), findsNothing);
      expect(find.byKey(initial), findsOneWidget);
      expect(find.byKey(success), findsNothing);
      expect(find.byKey(error), findsNothing);
      expect(find.byKey(notFound), findsNothing);
    });

    testWidgets('When LoadingStatus is equal to error and error content is not provided , should see initial content', (WidgetTester tester) async {
      await _pumpLoadingContainerByStatus(
        LoadingStatus.error,
        tester,
        provideErrorContent: false,
      );

      expect(find.byKey(loading), findsNothing);
      expect(find.byKey(initial), findsOneWidget);
      expect(find.byKey(success), findsNothing);
      expect(find.byKey(error), findsNothing);
      expect(find.byKey(notFound), findsNothing);
    });

    testWidgets('When LoadingStatus is equal to notFound and notFound content is not provided , should see initial content ', (WidgetTester tester) async {
      await _pumpLoadingContainerByStatus(
        LoadingStatus.notFound,
        tester,
        provideNotFoundContent: false,
      );

      expect(find.byKey(loading), findsNothing);
      expect(find.byKey(initial), findsOneWidget);
      expect(find.byKey(success), findsNothing);
      expect(find.byKey(error), findsNothing);
      expect(find.byKey(notFound), findsNothing);
    });
  });
}
