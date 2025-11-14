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
    if (_isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_hasLocation) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(
            'Localização capturada!',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_off_outlined,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Informar Localização!',
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Container de Status com borda quadrada
        Container(
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Ajuste: Borda quadrada
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              width: 1,
              color: theme.colorScheme.outline.withOpacity(0.7),
            ),
          ),
          child: _buildStatusContent(theme),
        ),
        const SizedBox(height: 10),

        // Ajuste: Trocado para ElevatedButton para ter fundo sólido
        ElevatedButton.icon(
          icon: const Icon(Icons.location_on_outlined),
          label: const Text('Buscar Localização Atual'),
          style: ElevatedButton.styleFrom(
            // Ajuste: Cor de fundo (sintaxe corrigida)
            backgroundColor: Colors.deepPurpleAccent,
            // Adicionado para contraste
            foregroundColor: Colors.white,
            // Ajuste: Botão quadrado
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            // Ajuste: Largura total e altura fixa
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _getCurrentUserLocation,
        ),
      ],
    );
  }
}
