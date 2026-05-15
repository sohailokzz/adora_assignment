import 'package:adora_assignment/routes/route_name.dart';
import 'package:adora_assignment/screens/history_screen/history_screen.dart';
import 'package:adora_assignment/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case RouteName.historyScreen:
        return MaterialPageRoute(
          builder: (_) => const HistoryScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
    }
  }
}
