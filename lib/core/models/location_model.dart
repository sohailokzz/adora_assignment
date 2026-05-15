import 'package:hive/hive.dart';

part 'location_model.g.dart';

@HiveType(typeId: 0)
class LocationModel extends HiveObject {
  @HiveField(0)
  double lat;

  @HiveField(1)
  double lng;

  @HiveField(2)
  DateTime timestamp;

  LocationModel({
    required this.lat,
    required this.lng,
    required this.timestamp,
  });
}
