import 'dart:async';
import 'dart:developer';

import 'package:adora_assignment/core/services/background_service.dart';
import 'package:adora_assignment/core/services/location_service.dart';
import 'package:flutter/material.dart';

class HomeScreenVM extends ChangeNotifier {
  double? latitude;
  double? longitude;

  bool isLoading = false;

  StreamSubscription? _subscription;

  bool get isTracking => _subscription != null;

  final LocationService _locationService = LocationService();

  Future<void> fetchLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();

      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;
        log("Current location → Lat: $latitude, Lng: $longitude");
      }
    } catch (e) {
      // optional: handle error (log or set error state)
    }

    isLoading = false;
    notifyListeners();
  }

  void startLiveTracking() {
    log("Live tracking started");
    _subscription?.cancel();

    _subscription = _locationService.getPositionStream().listen(
      (position) {
        latitude = position.latitude;
        longitude = position.longitude;
        log("Live Update → Lat: $latitude, Lng: $longitude");
        notifyListeners();
      },
      onError: (error) {
        // optional: handle stream errors
      },
    );

    notifyListeners(); // updates UI for tracking state
  }

  void stopLiveTracking() {
    log("Live tracking stopped");
    _subscription?.cancel();
    _subscription = null;
    notifyListeners();
  }

  Future<void> startBackgroundTracking() async {
    await BackgroundService.startService();
    notifyListeners();
  }

  Future<void> stopBackgroundTracking() async {
    await BackgroundService.stopService();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
