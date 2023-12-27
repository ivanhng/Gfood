import 'package:firebase_auth/firebase_auth.dart';
import 'package:gfood_app/components/data/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/components/data/models/detailmodel.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gfood_app/components/data/provider/database_provider.dart';
import 'package:gfood_app/screens/Restaurant/review_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../common/styles.dart'; // Import your data model classes

class DetailScreen extends StatefulWidget {
  final String place_id; // Receive the place_id as a parameter
  final Item restaurant; // Receive the restaurant data as a parameter
  DetailScreen({required this.place_id, required this.restaurant});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ApiService _reviewService = ApiService();
  RestaurantDetails? _restaurantDetails;
  List<Review> _allReviews = []; // Define the _allReviews variable here
  bool _isLoading = true;
  static const String _apiKey = 'AIzaSyA4rC5oTubZtq5xMxdtbWRmwb2ba5-MCmk';

  bool isFavorite = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _fetchDetailsAndReviews();
  }

  void _checkFavoriteStatus() async {
    bool status = await Provider.of<DatabaseProvider>(context, listen: false)
        .isFavorite(widget.place_id);
    setState(() {
      isFavorite = status;
    });
  }

  void _toggleFavoriteStatus() {
    print('Restaurant object in DetailScreen: ${widget.restaurant.toString()}');
    Provider.of<DatabaseProvider>(context, listen: false)
        .toggleFavorite(widget.restaurant);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _fetchDetailsAndReviews() async {
    RestaurantDetails? details;
    List<Review> combinedReviews = [];
    try {
      details = await _reviewService.fetchRestaurantDetails(widget.place_id);
      combinedReviews =
          await _reviewService.fetchCombinedReviews(widget.place_id);
      print(details);
      print(combinedReviews);
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString(); // Store the error message for displaying
      });
      return;
    }

    setState(() {
      _restaurantDetails = details;
      _allReviews = combinedReviews;
      _isLoading = false;
    });
  }

  Future<void> _launchURLMap(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURLPhone(String phoneNumber) async {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^+\d]'), '');

    String url = 'tel:$cleanNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator(); // Show a loading spinner
    }
    /*if (_restaurantDetails == null) {
      return Text('Error fetching restaurant details.');
    }*/
    if (_errorMessage != null) {
      return Text('Error: $_errorMessage');
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        toolbarHeight: 96.0,
        backgroundColor: black,
        title: Text('Restaurant Detail'),
        actions: [
          IconButton(
            splashRadius: 24.0,
            splashColor: Colors.red,
            padding: EdgeInsets.zero,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Colors.red,
            onPressed: _toggleFavoriteStatus,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      imageUrl: (widget.restaurant.photo_reference != null &&
                              widget.restaurant.photo_reference!.isNotEmpty)
                          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=${widget.restaurant.photo_reference}&key=$_apiKey'
                          : 'https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png', // Default image
                      height: 200.0, // Adjust the height as needed
                      width:
                          double.infinity, // Let the image take the full width
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, download) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(
                            value: download.progress,
                            strokeWidth: 1.5,
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Icon(Icons.image),
                        );
                      },
                    ),
                  ),

                  // Display name
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      widget.restaurant.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  // Display rating and location
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: customYellow,
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
                              '${widget.restaurant.rating}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(width: 32.0),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.restaurant.latitude != null &&
                                  widget.restaurant.longitude != null &&
                                  widget.restaurant.latitude != 0.0 &&
                                  widget.restaurant.longitude != 0.0) {
                                _launchURLMap(widget.restaurant.latitude!,
                                    widget.restaurant.longitude!);
                              } else {
                                // Handle the error, e.g., show a message to the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid location data!'),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: customBlue,
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
                                    widget.restaurant.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Phone number, Open hours, and Open/Closed status
                  InkWell(
                      onTap: () {
                        _launchURLPhone("${_restaurantDetails?.phoneNumber}");
                      },
                      child: Row(
                        children: [
                          Icon(Icons.phone),
                          Text(
                            "Phone Number: ${_restaurantDetails?.phoneNumber ?? 'N/A'}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                        ],
                      )),
                  // Displaying if the restaurant is currently open
                  Text(
                    _restaurantDetails?.currentOpeningHours?.openNow ?? false
                        ? "Open Now"
                        : "Closed",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            _restaurantDetails?.currentOpeningHours?.openNow ??
                                    false
                                ? Colors.green
                                : Colors.red),
                  ),

                  SizedBox(height: 16),

                  // Displaying the restaurant's weekly schedule
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _restaurantDetails
                            ?.currentOpeningHours?.weekdayText
                            ?.map((day) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child:
                                      Text(day, style: TextStyle(fontSize: 16)),
                                ))
                            .toList() ??
                        [],
                  ),
                  SizedBox(height: 16),
                  // Display customer reviews
                  Divider(
                    color: black,
                    thickness: 0.8,
                  ),
                  const SizedBox(height: 20.0),
                  _buildRatingComponent(),
                  Divider(
                    color: black,
                    thickness: 0.8,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Customer Reviews',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10.0),
                  ..._allReviews
                      .map((review) => _buildReviewWidget(review))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingComponent() {
    return Center(
      child: Column(
        children: [
          Text(
            'Rates and Reviews',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20.0),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            onRatingUpdate: (rating) async {
              bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(
                      place_id: widget.place_id,
                      rating: rating,
                      onReviewPosted: () {
                        _fetchDetailsAndReviews();
                      },
                    ),
                  ));
              if (result != null && result == true) {
                _fetchDetailsAndReviews();
              }
            },
            itemCount: 5,
            itemSize: 30.0,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildReviewWidget(Review review) {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: review.profilePhotoUrl == null
                    ? Image(
                        image: AssetImage('assets/images/profile.png'),
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: review.profilePhotoUrl!.toString(),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image(
                          image: AssetImage('assets/images/profile.png'),
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        ),
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  review.authorName.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black),
                ),
              ),
              _buildStars(review.rating),
              currentUserEmail == review.authorName
                  ? IconButton(
                      icon:
                          Icon(Icons.delete, color: Colors.red), // delete icon
                      onPressed: () async {
                        bool shouldDelete =
                            await _showDeleteConfirmationDialog();
                        if (shouldDelete) {
                          ApiService().deleteReviewByUserEmail(
                            place_id: widget.place_id,
                            userEmail: review
                                .authorName!, // Assuming authorName is the email here
                          );
                        }
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            review.text.toString(),
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 6.0),
          Divider(
            color: black,
            thickness: 0.8,
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Delete Review"),
              content: Text("Are you sure you want to delete this review?"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text("Yes, Delete"),
                  onPressed: () {
                    _fetchDetailsAndReviews();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false; // This returns false if the user just dismisses the dialog
  }

  Row _buildStars(double? rating) {
    // Handle the case where rating is null
    if (rating == null) {
      rating = 0; // Or set a default rating if needed
    }

    List<Widget> stars = [];
    for (double i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : Icons.star_border,
          color: customYellow,
        ),
      );
    }
    return Row(children: stars);
  }
}
