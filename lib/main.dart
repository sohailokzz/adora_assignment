import 'package:adora_assignment/core/models/location_model.dart';
import 'package:adora_assignment/core/services/background_service.dart';
import 'package:adora_assignment/core/services/notification_service.dart';
import 'package:adora_assignment/routes/route_name.dart';
import 'package:adora_assignment/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocationModelAdapter());
  await Hive.openBox<LocationModel>('locations');
  await Permission.notification.request();
  await createChannel();
  await NotificationService.initialize();
  await BackgroundService.initializeService();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adora Assignment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RouteName.homeScreen,
    );
  }
}
