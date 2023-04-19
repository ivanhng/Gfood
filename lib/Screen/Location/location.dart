import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapScreen extends StatefulWidget {
  @override
  _LocationMapScreenState createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Location'),
      ),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.77483, -122.419416),
          zoom: 12,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
