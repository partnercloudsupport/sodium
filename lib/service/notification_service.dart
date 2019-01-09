import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final NotificationDetails notificationDetails;

  NotificationService(
    this.localNotificationsPlugin,
    this.notificationDetails,
  );

  Future<Null> setDailyNotification(int id, String title, String body, Time time) async {
    await localNotificationsPlugin.showDailyAtTime(
      id,
      title,
      body,
      time,
      notificationDetails,
    );
  }

  Future<Null> cancelNotification(int id) async {
    await localNotificationsPlugin.cancel(id);
  }

  Future<Null> cancelAllNotification() async {
    await localNotificationsPlugin.cancelAll();
  }
}
