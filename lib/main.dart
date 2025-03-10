import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:save_maps/cubit/maps_pin_cubit.dart';
import 'package:save_maps/firebase_options.dart';
import 'package:save_maps/presentation/list_view_places_page.dart';
import 'package:save_maps/presentation/map_view_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GeolocatorPlatform.instance.checkPermission();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(BlocProvider(create: (context) => MapCubit(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Pines')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapViewPage()),
                );
              },
              child: Text('Abrir Mapa Aqui'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListViewPlacesPage()),
                );
              },
              child: Text('Ver Lugares Guardados'),
            ),
          ],
        ),
      ),
    );
  }
}
