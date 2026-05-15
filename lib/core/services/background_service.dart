import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:adora_assignment/core/services/location_service.dart';
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

    void startTracking() {
      subscription?.cancel();

      subscription = locationService.getPositionStream().listen((position) {
        log("BG → ${position.latitude}, ${position.longitude}");
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

    // IMPORTANT: start tracking immediately
    startTracking();
  }
}
