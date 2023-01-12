import 'dart:async';
import 'dart:math';

import 'package:blue_dot_test_app/models/places.dart';
import 'package:blue_dot_test_app/services/web_apis.dart';
import 'package:blue_dot_test_app/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  LocationService() {
    currentMapPosition = CameraPosition(
      target: locationLatLng,
      zoom: 14.4746,
    );
  }

  Location location = Location();
  LatLng locationLatLng = const LatLng(37.42796133580664, -122.085749655962);
  ValueNotifier<List<Place>> placesList = ValueNotifier([]);
  PermissionStatus permissionGranted = PermissionStatus.denied;
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  late CameraPosition currentMapPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String? currentSearchString;

  Future<void> isPermissionGranted() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
  }

  Future<void> getLocationPermission() async {
    await isPermissionGranted();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    showCurrentPosition();
  }

  Future<void> showCurrentPosition() async {
    if (permissionGranted != PermissionStatus.granted) {
      throw ('Location permission not granted');
    }
    LocationData locationData = await location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      locationLatLng = LatLng(locationData.latitude!, locationData.longitude!);
    }
    changeCurrentPosition();
  }

  Future<void> changeCurrentPosition() async {
    Log.d('${locationLatLng.latitude}, ${locationLatLng.longitude}');
    currentMapPosition = CameraPosition(
      target: locationLatLng,
      zoom: 14.4746,
    );
    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        currentMapPosition,
      ),
    );
  }

  Future<void> searchNearByPlaces(String searchQuery) async {
    if (searchQuery.isEmpty) return;
    currentSearchString = searchQuery;
    double radius = await getMapVisibleRadius();
    final result = await WebApiService().getNearByPlaces(
      locationLatLng,
      searchQuery,
      radius: radius.toInt(),
    );
    Log.d('Received ${result.length} results');
    placesList.value = List.from(result);
  }

  void updateLocation(LatLng latLng) {
    locationLatLng = latLng;
    placesList.value = List.from([]);
    changeCurrentPosition();
  }

  void updateSearchResults() {
    Log.d('updating search results');
    if (currentSearchString != null) {}
  }

  Future<double> getMapVisibleRadius() async {
    final GoogleMapController googleMapController = await controller.future;
    LatLngBounds visibleRegion = await googleMapController.getVisibleRegion();
    LatLng farLeft = visibleRegion.northeast;
    LatLng nearRight = visibleRegion.southwest;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((farLeft.latitude - nearRight.latitude) * p) / 2 +
        c(nearRight.latitude * p) *
            c(farLeft.latitude * p) *
            (1 - c((farLeft.longitude - nearRight.longitude) * p)) /
            2;
    double radiusInKm = 12742 * asin(sqrt(a));
    return radiusInKm * 1000;
  }
}
