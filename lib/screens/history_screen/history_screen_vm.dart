import 'dart:async';

import 'package:adora_assignment/core/services/location_storage_service.dart';
import 'package:flutter/material.dart';

class HistoryScreenVM extends ChangeNotifier {
  List locations = [];

  StreamSubscription? _subscription;

  void init() {
    loadData();

    _subscription = LocationStorageService.watch().listen((event) {
      loadData();
    });
  }

  void loadData() {
    locations = LocationStorageService.getAll();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
