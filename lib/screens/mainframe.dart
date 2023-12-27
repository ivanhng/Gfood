import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:gfood_app/common/navigation.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:gfood_app/screens/Login/questionaire.dart';
import 'package:gfood_app/screens/Restaurant/widgets/spinningwheel.dart';
import 'package:gfood_app/screens/Restaurant/detail_screen.dart';
import 'package:gfood_app/screens/Restaurant/favourite_screen.dart';
import 'package:gfood_app/screens/Restaurant/list_screen.dart';
import 'package:gfood_app/screens/Restaurant/search_screen.dart';
import 'package:gfood_app/screens/Restaurant/widgets/restaurant_card.dart';
import 'package:location/location.dart' as location;
import 'package:gfood_app/screens/Location/location.dart';
import 'package:gfood_app/screens/Setting/setting.dart';
import 'package:gfood_app/components/constant.dart';
import 'package:gfood_app/screens/Restaurant/top_recommendation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MainFrame extends StatefulWidget {
  final String title;

  const MainFrame({Key? key, required this.title}) : super(key: key);

  @override
  _MainFrameState createState() => _MainFrameState(title: title);
}

class _MainFrameState extends State<MainFrame> {
  final List<Widget> _pages;
  int _currentPage = 0;
  String _title;
  Position? _currentPosition;
  location.LocationData? _currentLocation;
  String? _currentAddress;
  Set<Marker> _markers = {};
  ApiService _apiService = ApiService();
  List<Item> _allRestaurants = [];

  bool _searchBarActive = false;

  @override
  void initState() {
    super.initState();
    checkUserPreferences();
  }

  _MainFrameState({required String title})
      : _title = title,
        _pages = [
          const ListScreen(),
          TopRecommendationsScreen(),
          SettingsPage(),
        ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
      if (_currentPage == 0) {
        _title = '🏠 Home';
      } else if (_currentPage == 1) {
        _title = '❤️ Top 10';
      } else {
        _title = '⚙ Settings';
      }
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _searchBarActive = !_searchBarActive;
    });
  }

  void _searchRestaurants() {
    // Implement search logic
  }

  void checkUserPreferences() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    print("Checking preferences for user: $userId");

    bool exists = await userPreferencesExist(userId);

    print("Document exists: $exists");

    if (!exists) {
      print("Navigating to QuestionnaireScreen");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
    } else {
      print("User's preferences already exist");
    }
  }

  Future<bool> userPreferencesExist(String? userId) async {
    if (userId == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('user_preferences')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<void> _getLocation() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = currentPosition;
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(
              currentPosition.latitude,
              currentPosition.longitude,
            ),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
      });
    } catch (e) {
      print('Error getting location: $e');
      return;
    }

    // Now that you have the location, you can also get the address
    if (_currentPosition != null) {
      await _getAddressFromLatLng(_currentPosition! as Position);
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        geocoding.Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> fetchUserPreferences(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('user_preferences')
        .doc(userId)
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception('User preferences not found');
    }
  }

  List<Item> adjustRestaurantsBasedOnPreferences(
      List<Item> restaurants, Map<String, dynamic> preferences) {
    List<Item> adjustedRestaurants = List.from(restaurants); // Make a copy

    // Handle budget preference
    String? budget = preferences['budget'];
    if (budget != null) {
      List<Item> budgetMatchingRestaurants = [];
      if (budget == "1-10") {
        budgetMatchingRestaurants = restaurants
            .where((restaurant) =>
                restaurant.price! >= 1 && restaurant.price! <= 10)
            .toList();
      } else if (budget == "11-20") {
        budgetMatchingRestaurants = restaurants
            .where((restaurant) =>
                restaurant.price! > 10 && restaurant.price! <= 20)
            .toList();
      } else if (budget == ">20") {
        budgetMatchingRestaurants =
            restaurants.where((restaurant) => restaurant.price! > 20).toList();
      }
      adjustedRestaurants.addAll(budgetMatchingRestaurants); // Duplication
    }

    // Handle vegetarian preference
    bool? isVegetarian = preferences['isVegetarian'];
    if (isVegetarian != null) {
      List<Item> vegetarianMatchingRestaurants = [];
      if (isVegetarian) {
        vegetarianMatchingRestaurants = restaurants
            .where(
                (restaurant) => restaurant.categories!.contains("Vegetarian"))
            .toList();
      } else {
        vegetarianMatchingRestaurants = restaurants
            .where(
                (restaurant) => !restaurant.categories!.contains("Vegetarian"))
            .toList();
      }
      adjustedRestaurants.addAll(vegetarianMatchingRestaurants); // Duplication
    }

    // Handle selectedCuisines preference
    List<String>? selectedCuisines =
        (preferences['selectedCuisines'] as List<dynamic>).cast<String>();

    if (selectedCuisines != null && selectedCuisines.isNotEmpty) {
      List<Item> cuisineMatchingRestaurants = restaurants.where(
        (restaurant) {
          for (String cuisine in selectedCuisines) {
            if (restaurant.categories!.contains(cuisine)) {
              return true;
            }
          }
          return false;
        },
      ).toList();

      adjustedRestaurants.addAll(cuisineMatchingRestaurants); // Duplication
    }

    return adjustedRestaurants;
  }

  Future<void> _showSpinningWheel(BuildContext context) async {
    // Fetch the restaurants from the API outside of the showDialog to avoid using the BuildContext across async gaps
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Fetch the user preferences and restaurants simultaneously
    final results = await Future.wait(
        [fetchUserPreferences(userId), _apiService.fetchRestaurants()]);

    Map<String, dynamic> userPreferences = results[0] as Map<String, dynamic>;
    List<Item> fetchedRestaurants = results[1] as List<Item>;

    // Adjust the probabilities here based on user preferences
    fetchedRestaurants = adjustRestaurantsBasedOnPreferences(
        fetchedRestaurants, userPreferences);

    setState(() {
      _allRestaurants = fetchedRestaurants;
    });
    // Now show the dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Using a different context variable name to avoid confusion
        return AlertDialog(
          title: const Text('Surprise Wheel'),
          content: SizedBox(
            height: 350,
            width: 350,
            child: SpinningWheel(
              items: _allRestaurants,
              onItemSelected: (selectedRestaurant) {
                // Now you have the selected restaurant as an Item directly

                // Close the spinning wheel dialog
                Navigator.of(context).pop();

                // Display the animated RestaurantCard
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: SizedBox(
                          width: 400, // Specify the width you want for the card
                          height: 250,
                          child: RestaurantCard(
                            item: selectedRestaurant,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    place_id: selectedRestaurant.place_id,
                                    restaurant: selectedRestaurant,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                  color: black,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        toolbarHeight: 96.0,
        backgroundColor: black,
        title: Text(
          _title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: kPrimaryLightColor.withOpacity(0.6),
            radius: 24,
            child: IconButton(
              splashRadius: 4.0,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.search),
              color: Theme.of(context).primaryIconTheme.color,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              //searchscreen()
            ),
          ),
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'Favorites') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteScreen()),
                );
              } else if (value == 'Request Location Permission') {
                bool permissionGranted = await _handleLocationPermission();
                if (permissionGranted) {
                  // Location permission granted, handle logic accordingly
                  _getLocation();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Location Permissions Required'),
                        content: const Text(
                            'Location permissions are not granted. Please go to app settings to enable location permissions for this app.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else if (value == 'Log Out') {
                FirebaseAuth.instance.signOut();
              } else if (value == 'wheel') {
                _showSpinningWheel(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Favorites',
                  child: Text('Favorites'),
                ),
                const PopupMenuItem(
                  value: 'wheel',
                  child: Text('Surprise Wheel'),
                ),
                const PopupMenuItem(
                  value: 'Request Location Permission',
                  child: Text('Request Location Permission'),
                ),
                const PopupMenuItem(
                  value: 'Log Out',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _pages[_currentPage],
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: black, // Change the background color here
        ),
        child: BottomNavigationBar(
          selectedItemColor: white,
          showUnselectedLabels: true,
          unselectedItemColor: white.withOpacity(0.6),
          unselectedLabelStyle: TextStyle(color: white.withOpacity(0.6)),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Top 10',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _currentPage,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
