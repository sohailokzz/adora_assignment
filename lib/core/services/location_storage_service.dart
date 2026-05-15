import 'package:adora_assignment/core/models/location_model.dart';
import 'package:hive/hive.dart';

class LocationStorageService {
  static final Box<LocationModel> _box = Hive.box<LocationModel>('locations');

  static Future<void> saveLocation({
    required double lat,
    required double lng,
  }) async {
    await _box.add(
      LocationModel(
        lat: lat,
        lng: lng,
        timestamp: DateTime.now(),
      ),
    );
  }

  static List<LocationModel> getAll() {
    return _box.values.toList().reversed.toList();
  }

  static Stream<BoxEvent> watch() {
    return _box.watch();
  }
}
