class Place {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  // Convertir Place a un mapa para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Convertir un mapa de Firebase a Place
  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'],
      name: map['name'],
      latitude: (map["latitude"] as num).toDouble(),
      longitude: (map["longitude"] as num).toDouble(),
    );
  }
}
