import 'package:blue_dot_test_app/services/location_service.dart';
import 'package:blue_dot_test_app/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final locationService =
          Provider.of<LocationService>(context, listen: false);
      await locationService.isPermissionGranted();
      if (mounted) {
        if (locationService.permissionGranted != PermissionStatus.granted) {
          showLocationPermissionDialog(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MapWidget();
  }

  Future<void> showLocationPermissionDialog(BuildContext context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Need Location Permission'),
          content: const Text(
            'We need location permission for this app to work properly.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final locationService =
                    Provider.of<LocationService>(context, listen: false);
                locationService.getLocationPermission();
              },
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }
}
