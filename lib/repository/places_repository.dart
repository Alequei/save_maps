import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:save_maps/model/place.dart';

class PlacesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPlace(Place place) async {
    await _firestore.collection('places').doc(place.id).set(place.toMap());
  }

  Stream<List<Place>> getPlaces() {
    return _firestore.collection('places').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Place.fromMap(doc.data())).toList();
    });
  }
}
