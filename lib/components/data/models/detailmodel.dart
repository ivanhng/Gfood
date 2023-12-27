import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantDetails {
  CurrentOpeningHours? currentOpeningHours;
  String? phoneNumber;
  List<Review>? reviews;

  RestaurantDetails({this.currentOpeningHours, this.phoneNumber, this.reviews});

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) {
    var reviewList = json['reviews'] as List?;
    List<Review>? reviewsList =
        reviewList?.map((review) => Review.fromJson(review)).toList();

    return RestaurantDetails(
      currentOpeningHours:
          CurrentOpeningHours.fromJson(json['current_opening_hours']),
      phoneNumber: json[
          'international_phone_number'], // Assuming this is where the phone number is located in your JSON
      reviews: reviewsList,
    );
  }
}

class CurrentOpeningHours {
  bool? openNow;
  List<String>? weekdayText;

  CurrentOpeningHours({this.openNow, this.weekdayText});

  factory CurrentOpeningHours.fromJson(Map<String, dynamic> json) {
    return CurrentOpeningHours(
      openNow: json['open_now'],
      weekdayText: List<String>.from(json['weekday_text']),
    );
  }
}

class Review {
  String? authorName;
  String? profilePhotoUrl;
  double? rating;
  int? time;
  String? text;

  Review(
      {this.authorName,
      this.profilePhotoUrl,
      this.rating,
      this.time,
      this.text});

  factory Review.fromJson(Map<String, dynamic> json) {
    double? rating = json['rating'] is int
        ? (json['rating'] as int).toDouble()
        : json['rating'];
    return Review(
      authorName: json['author_name'] ?? '',
      profilePhotoUrl: json['profile_photo_url'],
      rating: rating,
      time: json['time'],
      text: json['text'],
    );
  }

  // A factory constructor to generate a Review object from Firestore document
  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      authorName: data['name'],
      rating: data['rating'],
      time: data['time'],
      text: data['review'],
      // ... (other fields as necessary)
    );
  }
}

class YelpRestaurant {
  final String name;
  final List<String> categories;

  YelpRestaurant({required this.name, required this.categories});

  factory YelpRestaurant.fromJson(Map<String, dynamic> json) {
    List<String> categoryList = (json['categories'] as List)
        .map((category) => category['title'] as String)
        .toList();
    return YelpRestaurant(name: json['name'], categories: categoryList);
  }
}
