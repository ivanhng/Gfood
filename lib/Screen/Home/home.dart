import 'package:flutter/material.dart';
import 'package:gfood_app/Screen/Profile/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _searchController = TextEditingController();

  bool _searchBarActive = false;

  void _searchRestaurants() {
    // Implement your search logic here
    String searchText = _searchController.text;
    print('Searching for: $searchText');
  }

  void _toggleSearchBar() {
    setState(() {
      _searchBarActive = !_searchBarActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppBar(
              title: _searchBarActive
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Restaurant',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onSubmitted: (_) => _searchRestaurants(),
                    )
                  : const Text('Home'),
              actions: [
                _searchBarActive
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: _toggleSearchBar,
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _toggleSearchBar,
                      ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'profile') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    }
                    // Add other cases for different menu items here
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'profile',
                        child: Text('Profile'),
                      ),
                      PopupMenuItem(
                        value: 'Social Sharing',
                        child: Text('Social Sharing'),
                      ),
                      PopupMenuItem(
                        value: 'Favourites List',
                        child: Text('Favorites List'),
                      ),
                      PopupMenuItem(
                        value: 'Order Tracking',
                        child: Text('Order Tracking'),
                      ),
                      PopupMenuItem(
                        value: 'Meal Planner',
                        child: Text('Meal Planner'),
                      ),
                    ];
                  },
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.8,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.77483, -122.419416),
                  zoom: 12,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId('restaurant1'),
                    position: LatLng(37.77483, -122.419416),
                    infoWindow: InfoWindow(title: 'Restaurant 1'),
                  ),
                  const Marker(
                    markerId: MarkerId('restaurant2'),
                    position: LatLng(37.78502, -122.406417),
                    infoWindow: InfoWindow(title: 'Restaurant 2'),
                  ),
                  const Marker(
                    markerId: MarkerId('restaurant3'),
                    position: LatLng(37.79517, -122.400875),
                    infoWindow: InfoWindow(title: 'Restaurant 3'),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
