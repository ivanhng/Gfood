import 'package:flutter/material.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:gfood_app/screens/Restaurant/detail_screen.dart';
import 'package:gfood_app/screens/Restaurant/widgets/recommendation_card.dart';
import 'package:gfood_app/screens/Restaurant/widgets/restaurant_card.dart';

class TopRecommendationsScreen extends StatefulWidget {
  @override
  _TopRecommendationsScreenState createState() =>
      _TopRecommendationsScreenState();
}

class _TopRecommendationsScreenState extends State<TopRecommendationsScreen> {
  List<Item> topRatedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopRated();
  }

  _fetchTopRated() async {
    List<Item> topItems = await ApiService().getTopRatedRestaurants();
    topItems.sort((a, b) => b.rating!.compareTo(a.rating!)); // Sort by rating
    topItems = topItems.take(10).toList(); // Take top 10

    if (mounted) {
      // Check if the widget is still in the widget tree
      setState(() {
        topRatedItems = topItems;
        _isLoading =
            false; // Data fetching is done, stop showing loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator()); // Show loading spinner
    }
    return Scaffold(
      body: _buildRestaurantList(topRatedItems),
    );
  }

  Widget _buildRestaurantList(List<Item> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return RecommendationCard(
          item: items[index],
          onTap: () {
            print("Tapped on a Top Recommendation Restaurant Card!");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailScreen(
                place_id: items[index].place_id,
                restaurant: items[index],
              ),
            ));
          },
        );
        // Use 'item' instead of 'restaurant' as the named parameter
      },
    );
  }
}
