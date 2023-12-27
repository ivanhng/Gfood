class Restaurants {
  bool? error;
  String? message;
  int? founded;
  int? count;
  List<Item>? items;

  Restaurants({
    this.error,
    this.message,
    this.founded,
    this.count,
    this.items,
  });

  factory Restaurants.fromMap(Map<String, dynamic> map) {
    return Restaurants(
      error: map["error"],
      message: map["message"],
      count: map["count"],
      items: List<Item>.from(
        map["restaurants"].map(
          (x) => Item.fromMapMinimal(x),
        ),
      ),
    );
  }

  factory Restaurants.fromApi(Map<String, dynamic> map) {
    return Restaurants(
      count: map["results"].length,
      items: List<Item>.from(
        map["results"].map(
          (x) => Item.fromApi(x),
        ),
      ),
    );
  }

  factory Restaurants.fromSearchMap(Map<String, dynamic> map) {
    return Restaurants(
      error: map["error"],
      founded: map["founded"],
      count: map["count"],
      items: List<Item>.from(
        map["restaurants"].map(
          (x) => Item.fromMapMinimal(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'error': error,
        'message': message,
        'count': count,
        'restaurants': List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}

class Restaurant {
  bool? error;
  String? message;
  List<Item>? items;

  Restaurant({
    this.error,
    this.message,
    this.items,
  });

  factory Restaurant.fromApi(Map<String, dynamic> map) {
    return Restaurant(
      error: map['error'] as bool?,
      message: map['message'] as String?,
      items: List<Item>.from(map["results"].map((x) => Item.fromApi(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        'error': error,
        'message': message,
      };
}

class Item {
  String place_id;
  String? name;
  final String address;
  //String? pictureId;
  bool? isOpen;
  String? photo_reference;
  List<String>? photoUrl; // Add a photoUrl property to store the photo URL
  List<String>? categories;
  int? price;
  double? rating;
  double? latitude; // Nullable double for latitude
  double? longitude; // Nullable double for longitude
  final List<String> types; // List of strings for types (non-nullable)
  double? _averageRating;
  double get averageRating => _averageRating ?? 0.0; // Getter

  set averageRating(double value) => _averageRating = value; // Setter

  Item({
    required this.place_id,
    this.name,
    required this.address,
    //this.pictureId,
    this.photo_reference,
    this.photoUrl, // Initialize photoUrl
    this.categories,
    this.isOpen,
    this.price,
    this.rating,
    this.latitude,
    this.longitude,
    required this.types,
  }) {
    // Handle default values for nullable properties
    this.latitude ??= 0.0; // Default latitude to 0.0 if it's null
    this.longitude ??= 0.0; // Default longitude to 0.0 if it's null
  }

  factory Item.fromMapMinimal(Map<String, dynamic> map) {
    // Extract fields from the map
    final String place_id = map['place_id'];
    final name = map['name'] ?? ""; // Assign an empty string if 'name' is null
    final address =
        map['vicinity'] ?? ""; // Assign an empty string if 'address' is null
    final photo_reference = map['photos'] != null && map['photos'].isNotEmpty
        ? map['photos'][0]['photo_reference']
        : "";

    // Check for latitude and longitude and provide default values if they are null
    final double latitude = map['geometry']?['location']?['lat'] != null
        ? map['geometry']['location']['lat'].toDouble()
        : 0.0;
    final double longitude = map['geometry']?['location']?['lng'] != null
        ? map['geometry']['location']['lng'].toDouble()
        : 0.0;

    // Convert fields to appropriate types
    final double rating =
        map['rating'] != null ? map['rating'].toDouble() : 0.0;

    // Check if 'types' is not null and is a list of strings
    final types = map['types'] != null && map['types'] is List<dynamic>
        ? (map['types'] as List<dynamic>).cast<String>()
        : <String>[];

    return Item(
      place_id: place_id,
      name: name,
      address: address,
      photo_reference: photo_reference, // Use photo_reference here

      photoUrl: [],
      latitude: latitude,
      longitude: longitude,
      rating: rating,
      types: types,
    );
  }

  factory Item.fromApi(Map<String, dynamic> map) {
    // Convert fields to appropriate types
    final String place_id = map['place_id'];
    final double rating = map['rating'] != null
        ? map['rating'].toDouble()
        : 0.0; // Replace 'yourNumericField' with the actual field name
    return Item(
      place_id: place_id,
      name: map["name"],
      address: map["vicinity"],
      photo_reference: map["photos"] != null && map["photos"].isNotEmpty
          ? map["photos"][0]["photo_reference"]
          : null, // Use photo_reference here
      rating: rating,
      // Additional properties you want to include from the API response
      latitude: map['geometry']['location']['lat'],
      longitude: map['geometry']['location']['lng'],
      types: (map['types'] as List<dynamic>)
          .cast<String>(), // Parse types as a list of strings
    );
  }

  factory Item.fromMapDetail(Map<String, dynamic> map) {
    // Convert fields to appropriate types
    final String place_id = map['place_id'];
    final double rating = map['rating'] != null
        ? map['rating'].toDouble()
        : 0.0; // Replace 'yourNumericField' with the actual field name
    final bool isOpen = map['current_opening_hours'] != null
        ? map['current_opening_hours']['open_now']
        : false;
    return Item(
      place_id: place_id,
      name: map["name"],
      address: map["vicinity"],
      photo_reference: map["photos"] != null && map["photos"].isNotEmpty
          ? map["photos"][0]["photo_reference"]
          : null, // Use photo_reference here
      rating: rating,
      isOpen: isOpen,
      latitude: map['geometry']['location']['lat'],
      longitude: map['geometry']['location']['lng'],
      types: (map['types'] as List<dynamic>)
          .cast<String>(), // Parse types as a list of strings
    );
  }

  factory Item.fromDatabase(Map<String, dynamic> map) {
    return Item(
      place_id: map['place_id']
          as String, // Assuming place_id is a required field in your database
      name: map['name'] as String?,
      address: map['address'] ?? "",
      photo_reference: map['photo_reference'] as String?,
      rating: (map['rating'] != null) ? map['rating'].toDouble() : null,
      types: [], // Assuming a default empty list for types since it's a required field in the Item's constructor
    );
  }

  factory Item.fromFirestore(Map<String, dynamic> firestoreData) {
    return Item(
      place_id: firestoreData['place_id'] as String,
      name: firestoreData['name'] as String,
      address: firestoreData['address']
          as String, // add a default value or fetch from Firestore
      types: [], // add a default value or fetch from Firestore
      categories: List<String>.from(firestoreData[
          'categories']), // Casting the Firestore list to List<String>
      price: firestoreData['Price'] as int?,
      latitude: firestoreData['latitude'].toDouble(), // Convert to double
      longitude: firestoreData['longitude'].toDouble(), // Convert to double
      photo_reference: firestoreData['photo_reference'] as String,
      // Add other fields if necessary.
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'place_id': place_id,
      'name': name,
      'address': address,
      'photo_reference': photo_reference,
      'photoUrl': photoUrl,
      'rating': rating,
    };
  }
}
