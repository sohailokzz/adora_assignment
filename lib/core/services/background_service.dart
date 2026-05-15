import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:adora_assignment/core/services/location_service.dart';
import 'package:adora_assignment/core/services/location_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  static final FlutterBackgroundService _service = FlutterBackgroundService();

  static Future<void> initializeService() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        foregroundServiceNotificationId: 1,
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  static Future<void> startService() async {
    final isRunning = await _service.isRunning();

    if (!isRunning) {
      await _service.startService();
    } else {
      _service.invoke("startTracking");
    }
  }

  static Future<void> stopService() async {
    _service.invoke("stopService");
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    final locationService = LocationService();

    StreamSubscription? subscription;

    double? lastLat;
    double? lastLng;

    const double minDistance = 10; // meters

    double toRadians(double degree) {
      return degree * (pi / 180);
    }

    double calculateDistance(
      double lat1,
      double lng1,
      double lat2,
      double lng2,
    ) {
      const earthRadius = 6371000;

      final dLat = toRadians(lat2 - lat1);
      final dLng = toRadians(lng2 - lng1);

      final a =
          sin(dLat / 2) * sin(dLat / 2) +
          cos(toRadians(lat1)) *
              cos(toRadians(lat2)) *
              sin(dLng / 2) *
              sin(dLng / 2);

      final c = 2 * atan2(sqrt(a), sqrt(1 - a));

      return earthRadius * c;
    }

    void startTracking() {
      subscription?.cancel();

      subscription = locationService.getPositionStream().listen((position) {
        final lat = position.latitude;
        final lng = position.longitude;

        debugPrint("BG → $lat, $lng");

        // 🔥 DISTANCE FILTER
        if (lastLat != null && lastLng != null) {
          final distance = calculateDistance(
            lastLat!,
            lastLng!,
            lat,
            lng,
          );

          if (distance < minDistance) {
            return; // ignore small movement
          }
        }

        lastLat = lat;
        lastLng = lng;

        // 💾 SAVE ONLY SIGNIFICANT MOVEMENT
        LocationStorageService.saveLocation(
          lat: lat,
          lng: lng,
        );
      });
    }

    void stopTracking() async {
      await subscription?.cancel();
      subscription = null;
    }

    service.on("startTracking").listen((event) {
      startTracking();
    });

    service.on("stopService").listen((event) async {
      stopTracking();
      service.stopSelf();
    });

    // 🚀 start immediately
    startTracking();
  }
}
