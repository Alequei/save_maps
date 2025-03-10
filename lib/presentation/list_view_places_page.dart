import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:save_maps/cubit/maps_pin_cubit.dart';
import 'package:save_maps/model/place.dart';

class ListViewPlacesPage extends StatelessWidget {
  final GoogleMapController? mapController;

  const ListViewPlacesPage({super.key, this.mapController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, List<Place>>(
      builder: (context, places) {
        if (places.isEmpty) {
          return Center(child: Text("No hay lugares guardados."));
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Lista de Pins")),
            body: SafeArea(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];

                  return ListTile(
                    leading: Icon(Icons.place, color: Colors.blue),
                    title: Text(place.name),
                    subtitle: Text(
                      "Lat: ${place.latitude}, Lng: ${place.longitude}",
                    ),
                    onTap: () {
                      if (mapController != null) {
                        mapController!.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(place.latitude, place.longitude),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
