import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/service/notification_service.dart';
import 'package:test_api/test_api.dart';

class MockFlutterLocalNotificationPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

class MockNotificationDetails extends Mock implements NotificationDetails {}

void main() {
  MockFlutterLocalNotificationPlugin mockFlutterLocalNotificationPlugin;
  MockNotificationDetails mockNotificationDetails;

  setUp(() {
    mockFlutterLocalNotificationPlugin = MockFlutterLocalNotificationPlugin();
    mockNotificationDetails = MockNotificationDetails();
  });

  group('Notification service', () {
    test('When set daily notification, should call setDailyNotification method', () async {
      final id = 123;
      final title = 'title';
      final body = 'body';
      final time = Time(8, 0, 0);
      final notificationService = NotificationService(mockFlutterLocalNotificationPlugin, mockNotificationDetails);

      when(mockFlutterLocalNotificationPlugin.showDailyAtTime(id, title, body, time, mockNotificationDetails)).thenAnswer((_) => Future.value());

      await notificationService.setDailyNotification(id, title, body, time);

      verify(mockFlutterLocalNotificationPlugin.showDailyAtTime(id, title, body, time, mockNotificationDetails));
    });
  });
}
