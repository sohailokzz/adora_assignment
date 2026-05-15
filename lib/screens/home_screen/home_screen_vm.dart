import 'dart:async';
import 'dart:math';

import 'package:adora_assignment/core/services/background_service.dart';
import 'package:adora_assignment/core/services/location_service.dart';
import 'package:adora_assignment/core/services/location_storage_service.dart';
import 'package:flutter/material.dart';

class HomeScreenVM extends ChangeNotifier {
  double? latitude;
  double? longitude;

  bool isLoading = false;

  StreamSubscription? _subscription;

  bool get isTracking => _subscription != null;

  final LocationService _locationService = LocationService();

  double? _lastLat;
  double? _lastLng;

  static const double _minDistance = 10; // meters

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadius = 6371000;

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  Future<void> fetchLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();

      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;

        debugPrint("Current location → Lat: $latitude, Lng: $longitude");

        LocationStorageService.saveLocation(
          lat: latitude!,
          lng: longitude!,
        );
      }
    } catch (e) {
      debugPrint("Fetch location error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void startLiveTracking() {
    debugPrint("Live tracking started");

    _subscription?.cancel();

    _subscription = _locationService.getPositionStream().listen(
      (position) {
        final lat = position.latitude;
        final lng = position.longitude;

        debugPrint("Live Update → Lat: $lat, Lng: $lng");

        // 🔥 distance filter
        if (_lastLat != null && _lastLng != null) {
          final distance = _calculateDistance(
            _lastLat!,
            _lastLng!,
            lat,
            lng,
          );

          if (distance < _minDistance) {
            return; // ignore noise
          }
        }

        _lastLat = lat;
        _lastLng = lng;

        latitude = lat;
        longitude = lng;

        LocationStorageService.saveLocation(
          lat: lat,
          lng: lng,
        );

        notifyListeners();
      },
      onError: (error) {
        debugPrint("Live tracking error: $error");
      },
    );

    notifyListeners();
  }

  void stopLiveTracking() {
    debugPrint("Live tracking stopped");

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
