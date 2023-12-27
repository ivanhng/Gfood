import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gfood_app/common/navigation.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/components/data/provider/restaurant_provider.dart';
import 'package:gfood_app/screens/Restaurant/detail_screen.dart';
import 'package:gfood_app/screens/Restaurant/filter_screen.dart';
import 'package:gfood_app/screens/Restaurant/search_screen.dart';
import 'package:gfood_app/screens/Restaurant/widgets/animation_placeholder.dart';
import 'package:gfood_app/screens/Restaurant/widgets/restaurant_card.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late Animation _colorTween;
  Set<String> selectedCategories = {};
  List<Item> filteredItems = []; // New filtered items list
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    Future.delayed(Duration.zero, () {
      _fetchData();
    });
  }

  Future<void> _navigateToFilterScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilterScreen()),
    );

    if (result != null) {
      print('Filter result received: $result');

      final provider = Provider.of<RestaurantProvider>(context, listen: false);
      provider.filterRestaurants(result); // Apply the filters
      // No need to use setState here since you're using a provider
    }
  }

  Future<void> _fetchData() async {
    final provider = Provider.of<RestaurantProvider>(context, listen: false);
    try {
      await provider.fetchRestaurants();
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      return true;
    }
    return false;
  }

  Widget _buildGreetings(BuildContext context) {
    int hour = DateTime.now().hour;

    return FadeInUp(
      from: 20.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (hour >= 0 && hour < 12)
                  ? 'Good Morning 🧇'
                  : (hour >= 12 && hour < 15)
                      ? 'Good Afternoon  🍨'
                      : (hour >= 15 && hour < 18)
                          ? 'Good Evening  ☕'
                          : 'Good Night  🍗',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14.0),
            Text(
              'Search for your favourite restaurant',
              // style: TextStyles.kHeading1.copyWith(
              //   color: customBlack,
              //   fontSize: 32.0,
              //   height: 1.2,
              // ),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, _) {
        var items = provider.filteredRestaurants ?? [];
        print('Rendering list with ${items.length} items.');

        switch (provider.fetchState) {
          case FetchResultState.loading:
            return const Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: SpinKitFadingCircle(color: customBlue),
            );

          case FetchResultState.noData:
            return Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: AnimationPlaceholder(
                animation: 'assets/not-found.json',
                text: 'Oops! Looks like there are no restaurants available',
                hasButton: true,
                buttonText: 'Refresh',
                onButtonTap: _fetchData,
              ),
            );

          case FetchResultState.hasData:
            return FadeInUp(
              from: 20.0,
              duration: const Duration(milliseconds: 500),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) => RestaurantCard(
                  item: items.reversed.toList()[index],
                  onTap: () {
                    print("Tapped on a Restaurant Card!");
                    print(
                        'Navigating to details for restaurant: ${items.reversed.toList()[index]}');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        place_id: items.reversed.toList()[index].place_id,
                        restaurant: items.reversed.toList()[index],
                      ),
                    ));
                  },
                ),
              ),
            );

          case FetchResultState.failure:
            return Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: AnimationPlaceholder(
                animation: 'assets/no-internet.json',
                text: 'Oops! Looks like you have a network issue',
                hasButton: true,
                buttonText: 'Refresh',
                onButtonTap: _fetchData,
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: IconButton(
        onPressed: _navigateToFilterScreen,
        icon: Icon(Icons.sort),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(builder: (context, provider, _) {
      _colorTween = ColorTween(
        begin: Theme.of(context).scaffoldBackgroundColor,
        end: Theme.of(context).appBarTheme.backgroundColor,
      ).animate(_colorAnimationController);

      return Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: _scrollListener,
          child: ListView(
            children: [
              _buildGreetings(context),
              _buildFilterButton(),
              _buildList(context),
            ],
          ),
        ),
      );
    });
  }
}
