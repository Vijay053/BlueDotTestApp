import 'dart:async';

import 'package:blue_dot_test_app/models/places.dart';
import 'package:blue_dot_test_app/services/web_apis.dart';
import 'package:blue_dot_test_app/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  LocationService() {
    currentMapPosition = CameraPosition(
      target: LatLng(locationData.latitude!, locationData.longitude!),
      zoom: 14.4746,
    );
  }

  Location location = Location();
  LocationData locationData = LocationData.fromMap({
    'latitude': 37.42796133580664,
    'longitude': -122.085749655962,
  });
  ValueNotifier<List<Place>> placesList = ValueNotifier([]);
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  late CameraPosition currentMapPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Future<void> getLocationPermission() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> showCurrentPosition() async {
    if (_permissionGranted != PermissionStatus.granted) {
      throw ('Location permission not granted');
    }
    locationData = await location.getLocation();
    changeCurrentPosition();
  }

  Future<void> changeCurrentPosition() async {
    if (locationData.latitude != null && locationData.longitude != null) {
      Log.d('${locationData.latitude}, ${locationData.longitude}');
      currentMapPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 14.4746,
      );
      final GoogleMapController mapController = await controller.future;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        currentMapPosition,
      ));
    }
  }

  Future<void> searchNearByPlaces(String searchQuery) async {
    if (searchQuery.isEmpty) return;
    if (locationData.latitude != null && locationData.longitude != null) {
      placesList.value = await WebApiService().getNearByPlaces(
        LatLng(locationData.latitude!, locationData.longitude!),
        searchQuery,
        radius: 1500,
      );
    }
  }
}
