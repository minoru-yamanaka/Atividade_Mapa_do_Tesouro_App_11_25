import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foto/models/place.dart';
import 'package:foto/providers/greate_places.dart';
import 'package:foto/widgets/image_input.dart';
import 'package:foto/widgets/location_input.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({Key? key}) : super(key: key);

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _nomeRuaController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();

  File? _pickedImage;
  PlaceLocation? _pickedLocation; // Guarda Lat/Lng

  // Ajuste de Estilo: Espaçamento vertical padrão
  final _spacing = const SizedBox(height: 16);

  @override
  void dispose() {
    // Boa prática: Limpar os controllers
    _titleController.dispose();
    _noteController.dispose();
    _nomeRuaController.dispose();
    _cepController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  void _selectImage(File image) {
    _pickedImage = image;
  }

  void _selectLocation(PlaceLocation location) {
    _pickedLocation = location;
  }

  void _submitForm() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha o Título, a Imagem e a Localização.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final completeLocation = PlaceLocation(
      latitude: _pickedLocation!.latitude,
      longitude: _pickedLocation!.longitude,
      address: _pickedLocation!.address,
      nomeRua: _nomeRuaController.text,
      cep: _cepController.text,
      numero: _numeroController.text,
    );

    Provider.of<GreatePlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage!,
      completeLocation,
      _noteController.text,
    );

    Navigator.of(context).pop();
  }

  // Ajuste de Estilo: Tema reutilizável para os campos de texto
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Lugar')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                // Ajuste de Estilo: Padding aumentado
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: _buildInputDecoration(
                        'Título',
                        Icons.title_rounded,
                      ),
                    ),
                    _spacing,
                    TextField(
                      controller: _nomeRuaController,
                      decoration: _buildInputDecoration(
                        'Nome da Rua',
                        Icons.signpost_outlined,
                      ),
                    ),
                    _spacing,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _cepController,
                            decoration: _buildInputDecoration(
                              'CEP',
                              Icons.pin_drop_outlined,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _numeroController,
                            decoration: _buildInputDecoration(
                              'Nº',
                              Icons.numbers_rounded,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    _spacing,
                    TextField(
                      controller: _noteController,
                      decoration: _buildInputDecoration(
                        'Nota',
                        Icons.note_alt_outlined,
                      ),
                      maxLines: 3,
                    ),
                    _spacing,
                    ImageInput(_selectImage),
                    _spacing,
                    LocationInput(_selectLocation),
                  ],
                ),
              ),
            ),
          ),
          // Ajuste de Estilo: Botão com padding e estilo moderno
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                minimumSize: const Size(
                  double.infinity,
                  50,
                ), // Largura total, 50 de altura
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Cantos arredondados
                ),
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
    );
  }
}
