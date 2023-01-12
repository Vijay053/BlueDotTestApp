import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  CameraPosition currentMapPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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
    final locationData = await location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      changeCurrentPosition(
          LatLng(locationData.latitude!, locationData.longitude!));
    }
  }

  Future<void> changeCurrentPosition(LatLng newPosition) async {
    currentMapPosition = CameraPosition(
      target: newPosition,
      zoom: 14.4746,
    );
    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      currentMapPosition,
    ));
  }
}
