import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:save_maps/cubit/maps_pin_cubit.dart';
import 'package:save_maps/model/place.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  LatLng? _currentLocation; // Ubicación actual del usuario
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    context.read<MapCubit>().loadPlaces(); // Cargar lugares desde Firestore
  }

  // Obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si la ubicación está habilitada
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Verificar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    // Obtener la posición actual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Mover la cámara a la ubicación actual
    _controller?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
  }

  // Guardar un lugar en Firestore
  void _savePlace() {
    if (_selectedLocation != null && _nameController.text.isNotEmpty) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final newPlace = Place(
        id: id,
        name: _nameController.text,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );

      context.read<MapCubit>().addPlace(newPlace);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lugar guardado en Firebase')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa")),
      body: Stack(
        children: [
          BlocBuilder<MapCubit, List<Place>>(
            builder: (context, places) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentLocation ?? LatLng(-12.043180, -77.028240),
                  zoom: 15,
                ),
                myLocationEnabled: true, // Habilitar el icono de ubicación
                myLocationButtonEnabled: false, // Ocultar el botón por defecto
                markers: {
                  for (var place in places)
                    Marker(
                      markerId: MarkerId(place.id),
                      position: LatLng(place.latitude, place.longitude),
                      infoWindow: InfoWindow(title: place.name),
                    ),
                  if (_selectedLocation != null)
                    Marker(
                      markerId: MarkerId("selected"),
                      position: _selectedLocation!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      ),
                    ),
                },
                onTap: (position) {
                  setState(() {
                    _selectedLocation = position;
                  });
                },
                onMapCreated: (controller) {
                  _controller = controller;
                  if (_currentLocation != null) {
                    _controller!.animateCamera(
                      CameraUpdate.newLatLng(_currentLocation!),
                    );
                  }
                },
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nombre del lugar"),
                ),
                ElevatedButton(
                  onPressed: _savePlace,
                  child: Text("Guardar Lugar"),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.my_location),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
