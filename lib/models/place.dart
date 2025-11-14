import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address; // Endereço formatado (opcional)
  final String? nomeRua; // <-- ADICIONADO
  final String? cep;
  final String? numero;

  PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.nomeRua, // <-- ADICIONADO
    this.cep,
    this.numero,
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation? location;
  final File image;
  final String? note;

  Place({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
    this.note,
  });
}
