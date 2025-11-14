import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:foto/models/place.dart';

class LocationInput extends StatefulWidget {
  final Function(PlaceLocation) onSelectLocation;

  const LocationInput(this.onSelectLocation, {Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _hasLocation = false;
  bool _isLoading = false;

  // --- Cor do Botão (Rosa) ---
  final Color _buttonColor = const Color(0xFFFC7ACF);

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isLoading = true;
      _hasLocation = false;
    });

    try {
      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() => _isLoading = false);
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() => _isLoading = false);
          return;
        }
      }

      locationData = await location.getLocation();

      if (locationData.latitude == null || locationData.longitude == null) {
        setState(() => _isLoading = false);
        return;
      }

      final selectedLocation = PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
      );

      setState(() {
        _hasLocation = true;
      });

      widget.onSelectLocation(selectedLocation);
    } catch (e) {
      print("Erro ao pegar localização: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStatusContent(ThemeData theme) {
    // <-- AJUSTE IMPORTANTE: O "isLoading" estava faltando aqui -->
    if (_isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
      );
    }
    // <-- FIM DO AJUSTE -->

    if (_hasLocation) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Localização capturada!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    // Texto branco (removido opacity(1.0) desnecessário)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_off_outlined,
          color: Colors.white, // Cor branca
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Informar Localização!',
          style: TextStyle(color: Colors.white), // Cor branca
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // <-- AJUSTE: Botão movido para cima -->
        ElevatedButton.icon(
          icon: const Icon(Icons.location_on_outlined),
          label: const Text('Buscar Localização Atual'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor, // Cor rosa
            foregroundColor: Colors.black, // Texto preto (para contraste)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Botão quadrado
            ),
            minimumSize: const Size(double.infinity, 50), // Largura total
          ),
          onPressed: _getCurrentUserLocation, // <-- O "onPressed" está aqui
        ),
        // <-- FIM DO AJUSTE -->

        const SizedBox(height: 10),

        // <-- AJUSTE: Container de Status movido para baixo -->
        Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0), // Borda quadrada
            color: Colors.white.withOpacity(0.1),
            border: Border.all(
              width: 1,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          child: _buildStatusContent(theme),
        ),
        // <-- FIM DO AJUSTE -->
      ],
      
    );
  }
  
}