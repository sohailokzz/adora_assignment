import 'dart:async';

import 'package:adora_assignment/core/services/location_service.dart';
import 'package:flutter/material.dart';

class HomeScreenVM extends ChangeNotifier {
  double? latitude;
  double? longitude;

  StreamSubscription? _subscription;
  bool isLoading = false;
  bool get isTracking => _subscription != null;

  final LocationService _locationService = LocationService();

  Future<void> fetchLocation() async {
    isLoading = true;
    notifyListeners();
    final position = await _locationService.getCurrentLocation();

    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      isLoading = false;
      notifyListeners();
    }
  }

  void startLiveTracking() {
    _subscription?.cancel();

    _subscription = _locationService.getPositionStream().listen((position) {
      latitude = position.latitude;
      longitude = position.longitude;

      notifyListeners();
    });
  }

  void stopLiveTracking() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
