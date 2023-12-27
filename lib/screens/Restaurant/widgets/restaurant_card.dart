import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Item item;
  const RestaurantCard({Key? key, required this.item, this.onTap})
      : super(key: key);
  static const String _apiKey = 'AIzaSyA4rC5oTubZtq5xMxdtbWRmwb2ba5-MCmk';
  final VoidCallback? onTap;

  String _shortenLocation(String location) {
    // Maximum number of characters to display
    const int maxCharacters = 10;

    if (location.length <= maxCharacters) {
      return location;
    } else {
      // Truncate the location to the maximum number of characters and add an ellipsis
      return location.substring(0, maxCharacters - 3) + '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortenedLocation = _shortenLocation(item.address);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 22.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: black,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.6),
              spreadRadius: 1.0,
              blurRadius: 30.0,
              offset: const Offset(0, 3.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: FittedBox(
                        child: CachedNetworkImage(
                          imageUrl: (item.photo_reference != null &&
                                  item.photo_reference!.isNotEmpty)
                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=80&maxheight=80&photoreference=${item.photo_reference}&key=$_apiKey'
                              : 'https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png', // Provide a URL to your default empty image
                          height: 80.0,
                          width: 80.0,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, download) {
                            //print('https://maps.googleapis.com/maps/api/place/photo?maxwidth=80&maxheight=80&photoreference=${item.photo_reference}&key=$_apiKey');
                            // Delay for a short period to ensure the progress indicator is visible
                            Future.delayed(Duration(milliseconds: 100), () {
                              print('Image is loading...');
                            });

                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(
                                value: download.progress,
                                strokeWidth: 1.5,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            print('Image failed to load: $error');
                            return const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Icon(Icons.image),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the left
                            children: [
                              Text(
                                item.name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the left
                            children: [
                              Text(
                                item.isOpen ?? false ? "Open Now" : "Closed",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: item.isOpen ?? false
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.primaryContainer,
              thickness: 0.8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        '${item.rating}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32.0),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Flexible(
                          child: Text(
                            item.address!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
