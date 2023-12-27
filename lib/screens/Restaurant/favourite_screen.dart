import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/components/data/provider/database_provider.dart';
import 'package:gfood_app/screens/Restaurant/detail_screen.dart';
import 'package:gfood_app/screens/Restaurant/widgets/animation_placeholder.dart';
import 'package:gfood_app/screens/Restaurant/widgets/restaurant_card.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite';
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with TickerProviderStateMixin {
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

  Widget _buildListFavorite(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, _) {
        final favoriteRestaurants = provider.favorites;
        print('Favorite restaurant: $favoriteRestaurants');

        switch (provider.databaseResultState) {
          case DatabaseResultState.noData:
            return const Center(
              child: Text("You haven't added your favorite yet"),
            );

          case DatabaseResultState.hasData:
            return FadeInUp(
              from: 20.0,
              duration: const Duration(milliseconds: 500),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favoriteRestaurants.length,
                itemBuilder: (context, index) {
                  final favoriteRestaurant = favoriteRestaurants[index];
                  print("restaurant：${favoriteRestaurant.photo_reference}");
                  return RestaurantCard(
                    item: favoriteRestaurant,
                    onTap: () {
                      print("Tapped on a Favorite Restaurant Card!");
                      print(
                          'Navigating to details for favorite restaurant: $favoriteRestaurant');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          place_id: favoriteRestaurant.place_id,
                          restaurant: favoriteRestaurant,
                        ),
                      ));
                    },
                  );
                },
              ),
            );
          case DatabaseResultState.error:
            return const Center(
              child: AnimationPlaceholder(
                animation: 'assets/not-found.json',
                text: 'Sorry, there seems to be a problem',
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _colorTween = ColorTween(
      begin: Theme.of(context).scaffoldBackgroundColor,
      end: Theme.of(context).appBarTheme.backgroundColor,
    ).animate(_colorAnimationController);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        automaticallyImplyLeading: true,
        backgroundColor: black,
        toolbarHeight: 96.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Favourite Restaurants',
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
            IconButton(
              splashRadius: 24.0,
              splashColor: Colors.redAccent[100],
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ),
              color: black,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text(
                          'Are you sure you want to delete all favorites?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Provider.of<DatabaseProvider>(
                              context,
                              listen: false,
                            ).deleteAllFavorite();
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: _buildListFavorite(context),
      ),
    );
  }
}
