import 'dart:convert';

import 'package:blue_dot_test_app/models/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class WebApiService {
  static const String _apiKey = "AIzaSyAOuq5IodDRT186EdsPqA0EBrpOcua50fs";

  Future<List<Place>> getNearByPlaces(
    LatLng position,
    String searchString, {
    int radius = 1500,
  }) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude}%2C${position.longitude}&radius=$radius&type=$searchString&key=$_apiKey";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
