import 'package:blue_dot_test_app/models/places.dart';
import 'package:blue_dot_test_app/services/location_service.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'custom_info_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationService = Provider.of<LocationService>(context);
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: locationService.placesList,
            builder: (context, placesList, child) => GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: locationService.currentMapPosition,
              onMapCreated: (GoogleMapController controller) {
                locationService.controller.complete(controller);
                _customInfoWindowController.googleMapController = controller;
              },
              onCameraMove: (CameraPosition position) {
                locationService.locationLatLng = position.target;
                _customInfoWindowController.onCameraMove!();
              },
              onCameraIdle: () => locationService.updateSearchResults(),
              zoomControlsEnabled: false,
              markers: getMarkerWidgetList(placesList),
              onTap: (LatLng latLng) {
                _customInfoWindowController.hideInfoWindow!();
                locationService.updateLocation(latLng);
              },
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 150,
            offset: 70,
          ),
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0, -0.9),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  decoration:
                      const InputDecoration(suffixIcon: Icon(Icons.search)),
                  onSubmitted: (value) =>
                      locationService.searchNearByPlaces(value),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => locationService.showCurrentPosition(),
        // onPressed: () => locationService.showCurrentPosition(),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.location_searching_rounded,
          color: Colors.black,
        ),
      ),
    );
  }

  Set<Marker> getMarkerWidgetList(List<Place> markerList) {
    return markerList.map(
      (Place place) {
        final latLang = LatLng(
          place.geometry.location.lat,
          place.geometry.location.lng,
        );
        return Marker(
          markerId: MarkerId(place.placeId),
          position: latLang,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              CustomInfoWidget(place),
              latLang,
            );
          },
        );
      },
    ).toSet();
  }
}
