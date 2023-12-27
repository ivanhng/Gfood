import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfood_app/components/data/models/detailmodel.dart';
import 'package:gfood_app/components/data/provider/restaurant_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gfood_app/components/data/models/restaurant.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int currentPage = 1;
  String nextPageToken = '';
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
  static const String _detailBaseUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';
  static const String _apiKey = 'AIzaSyA4rC5oTubZtq5xMxdtbWRmwb2ba5-MCmk';
  double maxWidth = 80;
  double maxHeight = 80;

  Future<List<Item>> fetchGoogleMapsRestaurants(String? nextPageToken) async {
    List<Item> allItems = [];
    String url =
        '$_baseUrl?location=4.308,101.1537&radius=15000&sensor=true&types=cafe|restaurant|food&page=1&key=$_apiKey';
    if (nextPageToken != null) {
      url += '&pagetoken=$nextPageToken';
    }
    print('Fetching data from URL: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      if (response.body != null) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print('Response data: $jsonData');

        final List<Item> pageResults = (jsonData['results'] as List)
            .map((itemJson) => Item.fromMapMinimal(itemJson))
            .where((restaurant) {
          final types = restaurant.types;
          return types.contains('restaurant') ||
              types.contains('food') ||
              types.contains('cafe');
        }).toList();

        allItems.addAll(pageResults);

        if (jsonData.containsKey('next_page_token')) {
          // Introducing a delay before fetching next page, as Google suggests there might be a short delay
          await Future.delayed(Duration(seconds: 2));
          String newToken = jsonData['next_page_token'];
          List<Item> moreItems = await fetchGoogleMapsRestaurants(newToken);
          allItems.addAll(moreItems);
        }

        return allItems;
      } else {
        print('Response body is null');
        // Handle the case where the response body is null.
      }
    } else {
      print('API request failed with status code ${response.statusCode}');
      print('API response: ${response.body}');
      throw Exception('Failed to load Google Maps restaurant data');
    }

    return [];
  }

  Future<List<Item>> fetchRestaurants() async {
    try {
      final googleMapsRestaurants =
          await fetchGoogleMapsRestaurants(nextPageToken);
      final firebaseRestaurants = await fetchFirebaseRestaurants();

      // Create a map for efficient lookup of Firestore restaurants by place_id
      final firebaseRestaurantsMap = {
        for (var restaurant in firebaseRestaurants)
          restaurant.place_id: restaurant
      };

      // Merge the restaurants from Google Maps API with details from Firestore
      for (var restaurant in googleMapsRestaurants) {
        final matchingFirebaseRestaurant =
            firebaseRestaurantsMap[restaurant.place_id];
        if (matchingFirebaseRestaurant != null) {
          restaurant.price = matchingFirebaseRestaurant.price;
          restaurant.categories = matchingFirebaseRestaurant.categories;
        }
      }

      // Add any unique Firestore restaurants to the final list
      final allRestaurants = googleMapsRestaurants;
      for (var restaurant in firebaseRestaurants) {
        if (!allRestaurants.any((r) => r.place_id == restaurant.place_id)) {
          allRestaurants.add(restaurant);
        }
      }

      print('Google Maps restaurants: ${googleMapsRestaurants.length}');
      print('Firebase restaurants: ${firebaseRestaurants.length}');

      print('Printing firebaseRestaurants details...');
      for (var restaurant in allRestaurants) {
        print('Name: ${restaurant.name}');
        print('Place ID: ${restaurant.place_id}');
        print('Address: ${restaurant.address}');
        print('Price: ${restaurant.price}');
        print('Categories: ${restaurant.categories?.join(', ')}');
        // ... (any other fields you want to inspect)
        print('-----------------------------------------');
      }

      // Debugging: Print the length of the combined list
      print('Total restaurants fetched: ${allRestaurants.length}');

      // Check for null data in the list
      if (allRestaurants.any((restaurant) => restaurant == null)) {
        print('Null data found in the list of restaurants.');
        // Handle the null data here, or you can return an error state.
      }

      return allRestaurants;
    } catch (error) {
      throw Exception(
          'An error occurred while fetching restaurant list: $error');
    }
  }

  Future<List<Item>> fetchFirebaseRestaurants() async {
    List<Item> firebaseRestaurants = [];
    QuerySnapshot querySnapshot =
        await _firestore.collection('restaurants').get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      try {
        Item item = Item(
          name: doc['name'],
          place_id: doc['place_id'],
          address: doc['address'],
          price: doc['Price'],
          categories: List<String>.from(doc['categories']),
          types: [],
        );
        print('try:${doc.data()}');
        firebaseRestaurants.add(item);
      } catch (e) {
        print('Error processing Firestore restaurant data: $e');
        print('Problematic data: ${doc.data()}');
      }
    }

    return firebaseRestaurants;
  }

  Future<List<Review>> fetchReviewsByplace_id(String place_id) async {
    QuerySnapshot reviewSnapshot = await _firestore
        .collection('restaurants')
        .doc(place_id)
        .collection('reviews')
        .get(const GetOptions(source: Source.server));

    List<Review> firestoreReviews =
        reviewSnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();

    print('Fetched ${firestoreReviews.length} reviews from Firestore.');
    print('Fetched ${reviewSnapshot.docs.length} reviews from Firestore.');
    for (var doc in reviewSnapshot.docs) {
      print(doc.data());
    }

    return firestoreReviews;
  }

  Future<RestaurantDetails?> fetchRestaurantDetails(String place_id) async {
    try {
      var url = Uri.parse(
          '$_detailBaseUrl?place_id=$place_id&fields=current_opening_hours,reviews,international_phone_number&key=$_apiKey'); // Usually, the ID is part of the URL.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body != null) {
          var jsonResponse = json.decode(response.body);
          print('Response data: $jsonResponse');

          // Here we convert our JSON response to a RestaurantDetails object
          final restaurantDetails =
              RestaurantDetails.fromJson(jsonResponse['result']);
          print(
              'Fetched ${restaurantDetails.reviews?.length} reviews from the API.');

          // Display
          print(
              "Status: ${restaurantDetails.currentOpeningHours?.openNow == true ? 'Open' : 'Closed'}");
          print("Phone: ${restaurantDetails.phoneNumber}");
          for (var day
              in restaurantDetails.currentOpeningHours?.weekdayText ?? []) {
            print(day);
          }

          return restaurantDetails;
        }
      } else {
        print('Failed to load restaurant details');
      }
    } catch (error) {
      print('Error fetching restaurant details: $error');
      return null;
    }
    return null;
  }

  Future<List<Review>> fetchCombinedReviews(String place_id) async {
    //combine json and firestore
    // Step 1: Fetch API Data
    RestaurantDetails? apiDetails = await fetchRestaurantDetails(place_id);

    // Step 2: Fetch Firestore Data
    List<Review> firestoreReviews = await fetchReviewsByplace_id(place_id);

    // Step 3: Combine Data
    if (apiDetails?.reviews != null) {
      apiDetails?.reviews!.addAll(firestoreReviews);
      print('Total combined reviews: ${apiDetails?.reviews?.length}');

      return apiDetails!.reviews!;
    } else {
      print('Only Firestore reviews available: ${firestoreReviews.length}');
      return firestoreReviews;
    }
  }

  Future<bool> postReviewByuserEmail({
    required String place_id,
    required String userEmail,
    required double rating,
    required String review,
  }) async {
    try {
      final reviewData = {
        'name': userEmail,
        'rating': rating,
        'review': review,
        'date': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection('restaurants')
          .doc(place_id)
          .collection('reviews')
          .doc(userEmail) // Use the user's email as the document ID
          .set(reviewData);

      return true;
    } catch (error) {
      throw Exception('An error occurred while posting review: $error');
    }
  }

  Future<void> deleteReviewByUserEmail({
    required String place_id,
    required String userEmail,
  }) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(place_id)
          .collection('reviews')
          .doc(userEmail)
          .delete();

      print('Review deleted successfully.');
    } catch (error) {
      print('Detailed Error: $error');
      throw Exception('An error occurred while deleting the review: $error');
    }
  }

  Future<List<Item>> getTopRatedRestaurants() async {
    List<Item> allRestaurants = await fetchGoogleMapsRestaurants(null);

    // Calculate average rating for each restaurant
    for (Item restaurant in allRestaurants) {
      List<Review> combinedReviews =
          await fetchCombinedReviews(restaurant.place_id);
      double averageRating = calculateAverageRating(combinedReviews);
      restaurant.averageRating = averageRating;
    }

    // Sort restaurants based on average rating
    allRestaurants.sort((a, b) => b.averageRating
        .compareTo(a.averageRating)); // Note: This sorts in descending order

    // Return top 10 or as many as you'd like
    return allRestaurants.take(10).toList();
  }

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;

    double totalRating =
        reviews.fold(0.0, (prev, review) => prev + (review.rating ?? 0.0));
    return totalRating / reviews.length;
  }
}
