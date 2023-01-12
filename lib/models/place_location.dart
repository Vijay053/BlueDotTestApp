class PlaceLocation {

  PlaceLocation({required this.lat, required this.lng});

  PlaceLocation.fromJson(Map<dynamic, dynamic> parsedJson)
      : lat = parsedJson['lat'],
        lng = parsedJson['lng'];
  final double lat;
  final double lng;
}
