import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:save_maps/model/place.dart';

class MapCubit extends Cubit<List<Place>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MapCubit() : super([]) {
    loadPlaces();
  }

  void loadPlaces() async {
    final snapshot = await _firestore.collection('places').get();
    final places =
        snapshot.docs.map((doc) => Place.fromMap(doc.data())).toList();
    emit(places);
  }

  // Guardar lugar en Firebase
  Future<void> addPlace(Place place) async {
    await _firestore.collection('places').doc(place.id).set(place.toMap());
    loadPlaces(); // Recargar la lista de lugares
  }

  // Eliminar lugar de Firebase
  Future<void> deletePlace(String id) async {
    await _firestore.collection('places').doc(id).delete();
    loadPlaces();
  }
}
