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
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: locationService.currentMapPosition,
        onMapCreated: (GoogleMapController controller) {
          locationService.controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => locationService.getNearByPlaces('atm'),
        // onPressed: () => locationService.showCurrentPosition(),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.location_searching_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
