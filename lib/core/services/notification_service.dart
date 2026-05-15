import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: settings,
    );
  }

  static Future<void> showTrackingNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'location_tracking_channel',
          'Location Tracking',
          channelDescription: 'Tracks location in background',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: 1,
      title: 'Location Tracking Active',
      body: 'Your location is being tracked',
      notificationDetails: details,
    );
  }

  static Future<void> cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(id: 1);
  }
}
