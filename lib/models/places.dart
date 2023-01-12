import 'package:blue_dot_test_app/models/place_geometry.dart';

class Place {

  Place({
    required this.placeId,
    required this.name,
    required this.geometry,
  });

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
      : placeId = parsedJson['place_id'],
        name = parsedJson['name'],
        geometry = Geometry.fromJson(parsedJson['geometry']);
  final String placeId;
  final String name;
  final Geometry geometry;
}
