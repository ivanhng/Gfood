/*import 'package:flutter/material.dart';
import 'package:gfood_app/screens/Restaurant/home_screen.dart';
import 'package:gfood_app/screens/Restaurant/detail_screen.dart';
import 'package:gfood_app/screens/Restaurant/list_screen.dart';
import 'package:gfood_app/screens/Restaurant/review_screen.dart';
import 'package:gfood_app/screens/Restaurant/search_screen.dart';
import 'package:gfood_app/components/data/models/restaurant.dart'; // Import the Item class

Map<String, WidgetBuilder> allRoute(BuildContext context) {
  return {
    HomeScreen.routeName: (context) => const HomeScreen(),
    ListScreen.routeName: (context) => const ListScreen(),
    DetailScreen.routeName: (context) {
      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments is String) {
        final restaurant = Item(
          id: arguments,
          latitude: 0.0, // Provide a valid latitude value here
          longitude: 0.0, // Provide a valid longitude value here
          iconBackgroundColor: '#FF9E67',
        );
        return DetailScreen(restaurant: restaurant);
      } else if (arguments is Item) {
        return DetailScreen(restaurant: arguments);
      } else {
        // Provide a default Item instance
        final defaultRestaurant = Item(
          id: 'default_id',
          name: 'Default Restaurant',
          latitude: 0.0, // Provide a valid latitude value here
          longitude: 0.0, // Provide a valid longitude value here
          iconBackgroundColor: '#FF9E67',
        );
        return DetailScreen(restaurant: defaultRestaurant);
      }
    },
    ReviewScreen.routeName: (context) => ReviewScreen(
          id: ModalRoute.of(context)!.settings.arguments as String,
        ),
    SearchScreen.routeName: (context) => const SearchScreen(),
    // Add more routes as needed
  };
}*/
