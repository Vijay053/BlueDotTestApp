import 'package:blue_dot_test_app/models/place_geometry.dart';
import 'package:blue_dot_test_app/models/place_photos.dart';

class Place {
  Place({
    required this.placeId,
    required this.name,
    required this.geometry,
    required this.photos,
    required this.vicinity,
  });

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
      : placeId = parsedJson['place_id'],
        name = parsedJson['name'],
        vicinity = parsedJson['vicinity'],
        geometry = Geometry.fromJson(
          parsedJson['geometry'],
        ),
        photos = (parsedJson['photos'] != null)
            ? (parsedJson["photos"] as List)
                .map((review) => PlacePhotos.fromJson(review))
                .toList()
            : [];
  final String placeId;
  final String name;
  final String vicinity;
  final Geometry geometry;
  final List<PlacePhotos> photos;
}
