import 'package:blue_dot_test_app/models/places.dart';
import 'package:blue_dot_test_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

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
              },
              onCameraMove: (CameraPosition position) =>
                  locationService.locationLatLng = position.target,
              onCameraIdle: () => locationService.updateSearchResults(),
              zoomControlsEnabled: false,
              markers: getMarkerWidgetList(placesList),
              onTap: (LatLng latLng) {
                locationService.updateLocation(latLng);
              },
            ),
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
        return Marker(
          markerId: MarkerId(place.placeId),
          position: LatLng(
            place.geometry.location.lat,
            place.geometry.location.lng,
          ),
          infoWindow: InfoWindow(title: place.name, snippet: '*'),
          onTap: () {},
        );
      },
    ).toSet();
  }
}
