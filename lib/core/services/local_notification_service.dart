import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

Future<void> createChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'adora_tracking',
    'Location Tracking',
    description: 'Shows live location tracking',
    importance: Importance.high,
  );

  await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}
