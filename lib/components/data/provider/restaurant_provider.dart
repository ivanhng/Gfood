import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/components/data/models/detailmodel.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/screens/Restaurant/filter_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FetchResultState { loading, noData, hasData, failure }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  Restaurants? _restaurants;
  Restaurants? get restaurants => _restaurants;
  RestaurantDetails? _selectedRestaurant;

  String _message = '';
  String get message => _message;

  FetchResultState? _fetchState;
  FetchResultState? get fetchState => _fetchState;

  String nextPageToken = '';
  int totalCardCount = 0;

  List<Item> _items = [];

  List<Item> get items => _items;

  RestaurantProvider({required this.apiService}) {
    Future.delayed(Duration.zero, () {
      fetchAllRestaurants();
    });
  }

  bool setFetchState(FetchResultState newState) {
    if (_fetchState != newState) {
      _fetchState = newState;
      notifyListeners();
    }
    return true;
  }

  Future<void> fetchRestaurants() async {
    try {
      setFetchState(FetchResultState.loading);

      final restaurantList = await apiService.fetchRestaurants();

      if (restaurantList.isEmpty) {
        setFetchState(FetchResultState.noData);
        _message = 'No data available.';
      } else {
        setFetchState(FetchResultState.hasData);
        _restaurants = Restaurants(
          error: false,
          message: '',
          count: restaurantList.length,
          items: restaurantList,
        );
        allRestaurants = restaurantList;
        filteredRestaurants = List.from(allRestaurants);
        notifyListeners(); // Notify that the data has changed
      }
      print('Fetched restaurants: $allRestaurants'); // This line
    } catch (error) {
      // Handle errors here
      setFetchState(FetchResultState.failure);
      print('Error fetching data: $error');
      _message = 'An error occurred: $error';
    }
  }

  Future<void> fetchBatchOfRestaurants() async {
    try {
      setFetchState(FetchResultState.loading);

      final restaurantList =
          await apiService.fetchGoogleMapsRestaurants(nextPageToken);

      if (restaurantList.isEmpty) {
        setFetchState(FetchResultState.noData);
        _message = 'No data available.';
      } else {
        setFetchState(FetchResultState.hasData);
        _restaurants = Restaurants(
          error: false,
          message: '',
          count: restaurantList.length,
          items: restaurantList,
        );

        allRestaurants.addAll(restaurantList);
        filteredRestaurants = List.from(allRestaurants);
        notifyListeners(); // Notify that the data has changed

        // Update the nextPageToken with the new token from the response
        nextPageToken = apiService.nextPageToken;

        // Update the totalCardCount with the total count of items received so far
        totalCardCount += restaurantList.length;
      }
    } catch (error) {
      // Handle errors here
      setFetchState(FetchResultState.failure);
      _message = 'An error occurred: $error';
    }
  }

  Future<void> fetchAllRestaurants() async {
    int attempts = 0;
    const maxAttempts = 5; // Define max number of attempts to fetch the data.

    try {
      while (nextPageToken.isNotEmpty && attempts < maxAttempts) {
        await fetchBatchOfRestaurants();
        attempts++;
      }

      if (attempts == maxAttempts) {
        _message = 'Maximum fetch attempts reached';
        // You might want to throw an exception or handle this case differently
      }

      // After fetching all restaurants, print their categories:
      print('All Categories:');

      allRestaurants.forEach((restaurant) {
        print(
            'Restaurant: ${restaurant.name}, Categories: ${restaurant.categories}');
      });
    } catch (error) {
      // Handle errors here
      _message = 'An error occurred while fetching all restaurants: $error';
    }
  }

  List<Item> allRestaurants = []; // All unfiltered restaurants.
  List<Item> filteredRestaurants = []; // Filtered restaurants.

  void filterRestaurants(FilterCriteria criteria) {
    // If no filters have been applied, just return all restaurants
    if (criteria.selectedCuisines.isEmpty &&
        criteria.dietaryRequirement == null &&
        criteria.selectedPriceRange == null &&
        criteria.selectedAtmosphere == null &&
        criteria.selectedDiningTypes.isEmpty) {
      filteredRestaurants = allRestaurants;
      notifyListeners();
      return;
    }

    // Merge selectedCuisines and dietaryRequirement into totalCategories
    Set<String> totalCategories = {...criteria.selectedCuisines};
    if (criteria.dietaryRequirement != null) {
      totalCategories.add(criteria.dietaryRequirement!);
    }
    if (criteria.selectedAtmosphere != null) {
      totalCategories.add(criteria.selectedAtmosphere!);
    }
    if (criteria.selectedDiningTypes.isNotEmpty) {
      totalCategories.addAll(criteria.selectedDiningTypes!);
    }

    // Filter the restaurants based on the criteria
    filteredRestaurants = allRestaurants.where((restaurant) {
      // Match against the total categories (cuisine + dietary)
      bool matchesTotalCategories = totalCategories.isEmpty ||
          (restaurant.categories
                  ?.any((category) => totalCategories.contains(category)) ??
              false);

      // Match the price range
      bool matchesPriceRange = true; // default to true if no filter applied
      if (criteria.selectedPriceRange != null) {
        // Assuming your price is a number. Modify as per your actual representation.
        int? price = restaurant.price;
        if (criteria.selectedPriceRange == '1-10') {
          matchesPriceRange = (price != null && price >= 1 && price <= 10);
        } else if (criteria.selectedPriceRange == '11-20') {
          matchesPriceRange = (price != null && price >= 11 && price <= 20);
        } else if (criteria.selectedPriceRange == '>20') {
          matchesPriceRange = (price != null && price > 20);
        }
      }

      // Print debug information for each restaurant
      print('For restaurant ${restaurant.name}:');
      print('Matches Cuisine: $matchesTotalCategories');
      print('Matches Cuisine:${restaurant.categories}');
      print('Matches PriceRange: $matchesPriceRange');

      print('Matches Cuisine:${restaurant.price}');

      return matchesTotalCategories && matchesPriceRange;
    }).toList();

    // Notify any listeners about the filter changes
    notifyListeners();

    // Print the criteria used for filtering
    print('Criteria Used:');
    print('Selected Cuisines: ${criteria.selectedCuisines}');
    print('Dietary Requirement: ${criteria.dietaryRequirement}');
    print('Selected Price Range: ${criteria.selectedPriceRange}');
    print('Filtered restaurants after applying filter: $filteredRestaurants');
  }
}
