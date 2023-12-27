import 'package:flutter/material.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/components/data/database/database_helper.dart'; // Adjust this import

enum DatabaseResultState { loading, noData, hasData, error }

class DatabaseProvider extends ChangeNotifier {
  final FirestoreHelper firestoreHelper; // Updated the helper type

  List<Item> _favorites = [];
  List<Item> get favorites => _favorites;

  String _message = '';
  String get message => _message;

  DatabaseResultState? _databaseResultState;
  DatabaseResultState? get databaseResultState => _databaseResultState;

  DatabaseProvider({required this.firestoreHelper}) {
    // Updated the constructor type
    _getFavorites();
  }

  void _getFavorites() async {
    _favorites = await firestoreHelper
        .getFavorites(); // Changed databaseHelper to firestoreHelper

    // Print each fetched favorite
    for (var favorite in _favorites) {
      print(
          'Fetched favorite: ${favorite.toString()},${favorite.name},${favorite.address},${favorite.photo_reference}');
    }

    if (_favorites.isNotEmpty) {
      _databaseResultState = DatabaseResultState.hasData;
    } else {
      _databaseResultState = DatabaseResultState.noData;
      _message = 'Database is empty';
    }

    notifyListeners();
  }

  Future<void> addFavorite(Item restaurant) async {
    try {
      await firestoreHelper.insertFavorite(
          restaurant); // Changed databaseHelper to firestoreHelper
      print("add:${restaurant.photo_reference}");
      _getFavorites();
    } catch (e) {
      _databaseResultState = DatabaseResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  // This method either adds or removes a restaurant from favorites.
  Future<void> toggleFavorite(Item restaurant) async {
    // Check if the restaurant is currently a favorite
    bool currentlyFavorite = await isFavorite(restaurant.place_id);

    if (currentlyFavorite) {
      // If it's currently a favorite, remove it.
      deleteFavoriteById(restaurant.place_id);
    } else {
      // If it's not currently a favorite, add it.
      addFavorite(restaurant);
    }
    print('Toggled favorite for restaurant: ${restaurant.name}');
    print('Photo URL: ${restaurant.photo_reference}');

    notifyListeners();
  }

  Future<bool> isFavorite(String id) async {
    final favorite = await firestoreHelper
        .getFavoriteById(id); // Changed databaseHelper to firestoreHelper
    return favorite != null; // Updated this condition
  }

  void deleteFavoriteById(String id) async {
    try {
      await firestoreHelper
          .deleteFavorite(id); // Changed databaseHelper to firestoreHelper
      _getFavorites();
    } catch (e) {
      _databaseResultState = DatabaseResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void deleteAllFavorite() async {
    try {
      await firestoreHelper
          .deleteAllFavorite(); // Changed databaseHelper to firestoreHelper
      _getFavorites();
    } catch (e) {
      _databaseResultState = DatabaseResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
