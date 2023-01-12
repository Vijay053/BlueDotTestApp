import 'package:blue_dot_test_app/models/place_location.dart';

class Geometry {
  final PlaceLocation location;

  Geometry({required this.location});

  Geometry.fromJson(Map<dynamic, dynamic> parsedJson)
      : location = PlaceLocation.fromJson(parsedJson['location']);
}
