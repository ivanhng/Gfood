/*import 'package:flutter/material.dart';
import 'package:gfood_app/screens/top_recommendations_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapScreen extends StatefulWidget {
  @override
  _LocationMapScreenState createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 5,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.77483, -122.419416),
                zoom: 12,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Expanded(
            flex: 5,
            child: TopRecommendationsScreen(),
          ),
        ],
      ),
    );
  }
}

class LocationScreen extends StatelessWidget {
  static const String routeName = '/location';

  static Route route()[
    return MaterialPageRoute(
      builder: (_) => LocationScreen(),
      settings: const RouteSettings(name: routeName),
    );
    
      
  ]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Container(height:MediaQuery.of(context).size.height,
          width:double.infinity,
          child:GoogleMap(initialCameraPosition: CameraPosition)
          )
        ]
      )

    )
  }

}
*/