import 'package:blue_dot_test_app/services/web_apis.dart';

class PlacePhotos {
  PlacePhotos({
    required this.photoReference,
    required this.height,
    required this.width,
  });

  PlacePhotos.fromJson(Map<dynamic, dynamic> parsedJson)
      : photoReference = parsedJson['photo_reference'],
        height = parsedJson['height'],
        width = parsedJson['width'];
  final String photoReference;
  final int height;
  final int width;

  String get photoThumbUrl {
    return "https://maps.googleapis.com/maps/api/place/photo?"
        "maxwidth=200"
        "&photo_reference=$photoReference"
        "&key=${WebApiService.apiKey}";
  }

  String get photoUrl {
    return "https://maps.googleapis.com/maps/api/place/photo?"
        "maxwidth=1600"
        "&photo_reference=$photoReference"
        "&key=${WebApiService.apiKey}";
  }
}
