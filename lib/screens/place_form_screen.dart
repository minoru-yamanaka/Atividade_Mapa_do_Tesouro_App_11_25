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
  // --- Controladores ---
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _nomeRuaController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();

  // --- Variáveis de Estado ---
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  // --- Cores Personalizadas ---
  final Color _backgroundColor = const Color(0xFF27C5B2);
  final Color _buttonColor = const Color(0xFFFC7ACF);

  // --- Constante de Espaçamento ---
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

  // Ajuste de Estilo: Tema para os campos de texto no fundo escuro
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white), // Texto do label branco
      prefixIcon: Icon(icon, color: Colors.white, size: 20), // Ícone branco
      filled: true,
      fillColor: Colors.white.withOpacity(0.1), // Preenchimento sutil
      // Borda padrão
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0), // Bordas quadradas
        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
      ),
      // Borda ao focar
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0), // Bordas quadradas
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo aplicada
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Novo Lugar'),
        // AppBar com a mesma cor e sem sombra
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white, // Cor do texto e ícones da appbar
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Padding aumentado
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white), // Texto digitado branco
                      decoration: _buildInputDecoration(
                        'Título',
                        Icons.title_rounded,
                      ),
                    ),
                    _spacing,
                    TextField(
                      controller: _nomeRuaController,
                      style: const TextStyle(color: Colors.white),
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
                            style: const TextStyle(color: Colors.white),
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
                            style: const TextStyle(color: Colors.white),
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
                      style: const TextStyle(color: Colors.white),
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

          // --- Botão Adicionar (Estrutura Corrigida) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonColor, // Cor rosa do botão
                foregroundColor: Colors.black, // Cor do texto (preto)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Botão quadrado
                ),
                minimumSize: const Size(double.infinity, 50), // Largura total
              ),
              onPressed: _submitForm,
            ),
            
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}