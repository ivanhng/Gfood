import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/common/navigation.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:gfood_app/screens/Restaurant/detail_screen.dart';
import 'package:gfood_app/screens/Restaurant/widgets/animation_placeholder.dart';
import 'package:gfood_app/screens/Restaurant/widgets/restaurant_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  ApiService _apiService = ApiService();
  List<Item> _allRestaurants = [];
  List<Item> _filteredRestaurants = [];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  void _loadRestaurants() async {
    try {
      _allRestaurants = await _apiService.fetchRestaurants();
      setState(() {
        _filteredRestaurants = _allRestaurants;
      });
    } catch (error) {
      print('Failed to fetch restaurants: $error');
      // Handle error as needed
    }
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      _filteredRestaurants = _allRestaurants.where((restaurant) {
        // Convert both to lowercase for a case-insensitive comparison
        return restaurant.name
                ?.toLowerCase()
                .contains(_searchQuery.toLowerCase()) ??
            false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        toolbarHeight: 96.0,
        backgroundColor: black,
        title: TextField(
          onChanged: _updateSearchQuery,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(
                color:
                    Colors.white.withOpacity(0.5)), // Make hint text lighter.
            filled: true, // Fill the text field.
            fillColor: Colors.white.withOpacity(0.1), // Slight white fill.
            border: OutlineInputBorder(
              // Outline border.
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search,
                color: Colors.white), // Search icon on the left.
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _filteredRestaurants[index];
          // Replace the ListTile with RestaurantCard
          return RestaurantCard(
            item: restaurant,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailScreen(
                  place_id: restaurant.place_id,
                  restaurant: restaurant,
                ),
              ));
            },
          );
        },
      ),
    );
  }
}


/*class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _colorAnimationController;
  late Animation _colorTween;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
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

  @override
  Widget build(BuildContext context) {
    _colorTween = ColorTween(
      begin: Theme.of(context).scaffoldBackgroundColor,
      end: Theme.of(context).appBarTheme.backgroundColor,
    ).animate(_colorAnimationController);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: AnimatedBuilder(
            animation: _colorAnimationController,
            builder: (context, child) {
              return AppBar(
                elevation: 0.0,
                titleSpacing: 24.0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: _colorTween.value,
                toolbarHeight: 96.0,
                title: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.6),
                        radius: 24.0,
                        child: IconButton(
                          splashRadius: 4.0,
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back),
                          color: Theme.of(context).primaryIconTheme.color,
                          onPressed: () {
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).setSearchState(SearchResultState.searching);
                            Navigation.back();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        showCursor: true,
                        cursorColor: Theme.of(context).iconTheme.color,
                        decoration: InputDecoration(
                          hintText: 'Kafe Cemara',
                          isCollapsed: true,
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.8),
                          contentPadding: const EdgeInsets.all(10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[500]!,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    Provider.of<SearchProvider>(
                                      context,
                                      listen: false,
                                    ).fetchRestaurantSearchResult(query: '');
                                  },
                                  child: const Icon(Icons.close),
                                )
                              : null,
                        ),
                        onChanged: (query) {
                          if (query.isNotEmpty) {
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).fetchRestaurantSearchResult(query: query);
                          } else {
                            Provider.of<SearchProvider>(
                              context,
                              listen: false,
                            ).setSearchState(SearchResultState.searching);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: SafeArea(
          child: Consumer<SearchProvider>(
            builder: (context, provider, _) {
              switch (provider.searchState) {
                case SearchResultState.searching:
                  return const AnimationPlaceholder(
                    animation: 'assets/loading.json',
                    text: 'Cari restoran',
                  );
                case SearchResultState.hasData:
                  return FadeInUp(
                    from: 20.0,
                    duration: const Duration(milliseconds: 500),
                    child: ListView.builder(
                      itemCount: provider.restaurants!.items!.length,
                      itemBuilder: (context, index) {
                        return RestaurantCard(
                          item: provider.restaurants!.items![index],
                        );
                      },
                    ),
                  );
                case SearchResultState.noData:
                  return const AnimationPlaceholder(
                    animation: 'assets/not-found.json',
                    text: 'Ops! Sepertinya restoran tidak tersedia',
                  );
                case SearchResultState.failure:
                  return AnimationPlaceholder(
                    animation: 'assets/no-internet.json',
                    text: 'Ops! Sepertinya koneksi internetmu dalam masalah',
                    hasButton: true,
                    buttonText: 'Refresh',
                    onButtonTap: () => provider.fetchRestaurantSearchResult(),
                  );
                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}*/
