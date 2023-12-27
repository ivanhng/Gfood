import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MarkerType {
  Restaurant,
  Default,
}

class CustomMarker extends Marker {
  final MarkerType markerType;

  CustomMarker({
    required MarkerId markerId,
    required LatLng position,
    required InfoWindow infoWindow,
    required this.markerType,
    required Null Function() onTap,
    // Other properties...
  }) : super(
          markerId: markerId,
          position: position,
          infoWindow: infoWindow,
          // Other properties...
        );
}
