import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';

class FirestoreHelper {
  final CollectionReference favoritesCollection =
      FirebaseFirestore.instance.collection('favorite');

  /// Insert favorite
  Future<void> insertFavorite(Item restaurant) async {
    try {
      await favoritesCollection
          .doc(restaurant.place_id)
          .set(restaurant.toMap());
    } catch (error) {
      print("Error inserting restaurant: $error");
    }
  }

  /// Get all favorite
  Future<List<Item>> getFavorites() async {
    QuerySnapshot snapshot = await favoritesCollection.get();
    return snapshot.docs
        .map((doc) => Item.fromDatabase(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get favorite by id
  Future<Item?> getFavoriteById(String place_id) async {
    DocumentSnapshot doc = await favoritesCollection.doc(place_id).get();
    if (doc.exists) {
      return Item.fromDatabase(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  /// Delete all favorite
  Future<void> deleteAllFavorite() async {
    QuerySnapshot snapshot = await favoritesCollection.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Delete favorite by ID
  Future<void> deleteFavorite(String place_id) async {
    await favoritesCollection.doc(place_id).delete();
  }
}
